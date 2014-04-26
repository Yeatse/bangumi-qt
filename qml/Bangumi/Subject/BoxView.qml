import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    id: root;

    width: horiView.width;
    height: horiView.height;

    property bool loading: false;

    function loadDetail(){
        loading = true;
        var url = "/user/"+core().getUID()+"/progress";
        var get = { "subject_id": sid };
        var callback = function(obj){
            loading = false;
            if (obj != null && Array.isArray(obj.eps)){
                var parse = function(value){
                    for (var i=0; i<episodeModel.count; i++){
                        if (episodeModel.get(i).id == value.id){
                            var prop = {
                                view_status_id: value.status.id,
                                view_status_name: value.status.cn_name
                            };
                            episodeModel.set(i, prop);
                            break;
                        }
                    }
                }
                obj.eps.forEach(parse);
            }
        }
        core().api(url, true, null, get, callback);
    }

    CommonDialog {
        id: boxDialog;

        function setData(index){

        }

        buttonTexts: ["确认", "取消"];

        content: Item {
            id: container;

            width: boxDialog.platformContentMaximumWidth;
            height: boxColumn.height + platformStyle.paddingMedium*2;

            Column {
                id: boxColumn;
                anchors {
                    left: parent.left; top: parent.top;
                    right: parent.right; margins: platformStyle.paddingMedium;
                }
                spacing: platformStyle.paddingMedium;
                ButtonRow {
                    id: buttonRow;
                    width: parent.width;
                    ToolButton {
                        objectName: "watched";
                        text: "看过";
                    }
                }
            }
        }
    }

    SubjectHeader {
        id: viewHeader;
        title: "格子";
    }

    GridView {
        id: view;
        anchors {
            fill: parent; topMargin: viewHeader.height;
        }
        clip: true;
        model: episodeModel;
        cellWidth: 90;
        cellHeight: 90;

        delegate: Item {
            id: gridItem;
            width: view.cellWidth;
            height: view.cellHeight;

            MouseArea {
                id: mouseArea;
                anchors.fill: parent;
                onClicked: {
                    if (!loading){
                        boxDialog.open();
                    }
                }
            }

            Rectangle {
                id: cell;
                anchors.centerIn: parent;
                width: platformStyle.graphicSizeLarge;
                height: platformStyle.graphicSizeLarge;
                color: view_status_id == 0 ? "#66ccff" : "#1080dd";
            }

            Label {
                anchors.centerIn: parent;
                text: sort;
            }

            Rectangle {
                id: mask;
                anchors.fill: cell;
                color: "black";
                opacity: 0.3;
                visible: mouseArea.pressed;
            }
        }
    }

    BusyIndicator {
        anchors.centerIn: parent;
        running: true;
        visible: loading;
        width: platformStyle.graphicSizeLarge;
        height: platformStyle.graphicSizeLarge;
    }

    ScrollBar {
        anchors { right: view.right; top: view.top; }
        flickableItem: view;
    }
}
