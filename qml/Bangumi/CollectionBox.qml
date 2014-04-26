import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1

CommonDialog {
    id: root;

    property string sid;
    property bool loading: false;
    property bool dataReady: false;

    function getDetail(){
        dataReady = false;
        if (sid != ""){
            loading = true;
            var url = "/collection/"+sid;
            var callback = function(obj){
                loading = false;
                if (obj != null){
                    dataReady = true;
                    if (obj.status != null){
                        buttonRow.checkedButton = buttonRow.children[obj.status.id-1];
                        ratingStarRow.ratingValue = obj.rating;
                        tagField.text = obj.tag.join(",");
                        commentField.text = obj.comment;
                    } else {
                        buttonRow.checkedButton = buttonRow.children[0];
                        ratingStarRow.ratingValue = 0;
                        tagField.text = "";
                        commentField.text = "";
                    }
                }
            }
            core().api(url, true, null, {}, callback);
        }
    }

    function update(){
        if (sid != "" && dataReady){
            statusPaneText.loading = true;
            var url = "/collection/"+sid+"/update";
            var post = {
                status: buttonRow.checkedButton.objectName,
                comment: commentField.text,
                tags: tagField.text,
                rating: ratingStarRow.ratingValue
            }
            var callback = function(){
                statusPaneText.loading = false;
                favPage.getlist();
            }
            core().api(url, true, post, {}, callback);
        }
    }

    buttonTexts: ["确定", "取消"];
    onButtonClicked: {
        if (index == 0){
            update();
        }
    }

    Connections {
        id: heightChangeListener;
        target: null;
        onHeightChanged: {
            if (tagField.activeFocus || commentField.activeFocus){
                flickable.contentY = flickable.contentHeight - flickable.height;
            }
        }
    }

    content: Item {
        id: container;

        width: root.platformContentMaximumWidth;
        height: Math.min(root.platformContentMaximumHeight,
                         contentCol.height + platformStyle.paddingMedium*2);

        Flickable {
            id: flickable;
            anchors {
                fill: parent; margins: platformStyle.paddingMedium;
            }
            contentWidth: width;
            contentHeight: contentCol.height;
            boundsBehavior: Flickable.StopAtBounds;
            visible: !loading && dataReady;

            Column {
                id: contentCol;
                spacing: platformStyle.paddingMedium;
                ButtonRow {
                    id: buttonRow;
                    width: parent.width;
                    ToolButton {
                        objectName: "wish";
                        text: "想看";
                    }
                    ToolButton {
                        objectName: "collect";
                        text: "看过";
                    }
                    ToolButton {
                        objectName: "do";
                        text: "在看";
                    }
                    ToolButton {
                        objectName: "on_hold";
                        text: "搁置";
                    }
                    ToolButton {
                        objectName: "dropped";
                        text: "抛弃";
                    }
                }
                Label {
                    id: ratingLabel;
                    text: "我的评价:";
                }
                Item {
                    width: parent.width;
                    height: platformStyle.graphicSizeMedium;
                    RatingIndicator {
                        id: ratingStarRow;
                        anchors.centerIn: parent;
                        maximumValue: 10;
                        function valueText(){
                            var dict = ["无","天雷 1","巨雷 2","雷 3","较雷 4","不过不失 5",
                                        "还行 6","推荐 7","力荐 8","神作 9","超神作 10(请谨慎评价)"]
                            return "我的评价:<i>%1</i>".arg(dict[ratingValue]);
                        }
                        onRatingValueChanged: ratingLabel.text = valueText();
                    }
                    MouseArea {
                        anchors.fill: parent;
                        function setValue(x){
                            var c = Math.ceil((x-ratingStarRow.x) / ratingStarRow.width * 10);
                            ratingStarRow.ratingValue = Math.max(Math.min(c, 10), 0);
                        }
                        onPressed: setValue(mouseX);
                        onPositionChanged: setValue(mouseX);
                    }
                }
                Label {
                    text: "标签(使用半角空格或逗号隔开,最多10个)";
                }
                TextField {
                    id: tagField;
                    width: parent.width;
                }
                Label {
                    text: "吐槽(简评,最多200字)"
                }
                TextArea {
                    id: commentField;
                    width: parent.width;
                    height: platformStyle.graphicSizeLarge;
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
    }

    onStatusChanged: {
        if (status === DialogStatus.Closing){
            heightChangeListener.target = null;
        } else if (status === DialogStatus.Open){
            heightChangeListener.target = container;
        }
    }
}
