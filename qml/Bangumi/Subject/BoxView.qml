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
            // reset
            var i, prop = {
                view_status_id: 0,
                view_status_name: ""
            };
            for (i=0; i<episodeModel.count; i++){
                episodeModel.set(i, prop);
            }
            // set data
            if (obj != null && Array.isArray(obj.eps)){
                var parse = function(value){
                    for (i=0; i<episodeModel.count; i++){
                        if (episodeModel.get(i).id == value.id){
                            prop = {
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

        property int sortIndex: 0;
        property variant currentData: null;

        function setData(index){
            sortIndex = index + 1;
            var data = episodeModel.get(index);
            currentData = data;
            var checkedIndex;
            switch (data.view_status_id){
            case 1: checkedIndex = 2; break;
            case 2: checkedIndex = 0; break;
            case 3: checkedIndex = 3; break;
            default: checkedIndex = 4; break;
            }
            buttonRow.checkedButton = buttonRow.children[checkedIndex];
            titleText = "ep." + data.sort + "  " + data.name;
            if (data.name_cn != ""){
                boxTitleLabel.text = "中文标题：" + data.name_cn;
            } else {
                boxTitleLabel.text = "";
            }
            boxTimeLabel.text = "首播：" + data.airdate;
        }

        onAccepted: {
            var option = buttonRow.checkedButton.objectName;
            var url, post = null;
            if (option == "watchedto"){
                url = "/subject/"+sid+"/update/watched_eps";
                post = { "watched_eps": sortIndex };
            } else {
                url = "/ep/"+currentData.id+"/status/"+option;
            }
            var callback = function(){
                loading = false;
                loadDetail();
            }
            loading = true;
            core().api(url, true, post, {}, callback);
        }

        onButtonClicked: if (index == 0) accept();

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
                    ToolButton {
                        objectName: "watchedto";
                        text: "看到";
                    }
                    ToolButton {
                        objectName: "queue";
                        text: "想看";
                    }
                    ToolButton {
                        objectName: "drop";
                        text: "抛弃";
                    }
                    ToolButton {
                        objectName: "remove";
                        text: "撤销";
                    }
                }
                Label {
                    id: boxTitleLabel;
                    text: " ";
                }
                Label {
                    id: boxTimeLabel;
                    text: " ";
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
                        boxDialog.setData(index);
                        boxDialog.open();
                    }
                }
            }

            Rectangle {
                id: cell;
                property int vsi: view_status_id;
                onVsiChanged: cell.color = getColor();

                anchors.centerIn: parent;
                width: platformStyle.graphicSizeLarge;
                height: platformStyle.graphicSizeLarge;
                Component.onCompleted: cell.color = getColor();

                function getColor(){
                    switch (view_status_id){
                    case 1: return "#f09199";
                    case 2: return "#1080dd";
                    case 3: return "#d2d2d2";
                    }
                    if (play_status == "NA"){
                        return "#7f7f7f";
                    } else {
                        return "#66ccff";
                    }
                }
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
