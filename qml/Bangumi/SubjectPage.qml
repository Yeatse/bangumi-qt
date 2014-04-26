import QtQuick 1.1
import com.nokia.symbian 1.1
import "Subject"

MyPage {
    id: page;

    property string sid: "";
    onSidChanged: getSubject();

    property bool dataReady: false;

    function getSubject(){
        dataReady = false;
        if (sid != ""){
            loading = true;
            var url = "/subject/"+sid;
            var get = { "responseGroup": "large" }
            var callback = function(obj){
                loading = false;
                if (obj != null && !obj.error){
                    dataReady = true;
                    subjectView.loadDetail(obj);
                    episodeView.loadDetail(obj);
                    characterView.loadDetail(obj);
                    staffView.loadDetail(obj);
                    commentView.loadDetail(obj);
                    coldDown.start();
                }
            }
            core().api(url, false, null, get, callback);
        }
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back";
            onClicked: pageStack.pop();
        }
        ToolButton {
            iconSource: "gfx/favourite.png";
            enabled: dataReady;
            onClicked: signalCenter.createCollectBox(sid, title);
        }
    }

    Timer {
        id: coldDown;
        interval: 200;
        onTriggered: boxView.loadDetail();
    }

    ListModel { id: episodeModel; }

    ListView {
        id: horiView;
        visible: dataReady;
        anchors.fill: parent;
        highlightRangeMode: ListView.StrictlyEnforceRange;
        snapMode: ListView.SnapOneItem;
        orientation: ListView.Horizontal;
        boundsBehavior: Flickable.DragOverBounds;
        pressDelay: 150;

        model: VisualItemModel {
            SubjectView { id: subjectView; }
            BoxView { id: boxView; }
            EpisodeView { id: episodeView; }
            CharacterView { id: characterView; }
            StaffView { id: staffView; }
            CommentView { id: commentView; }
        }
    }

    Row {
        id: indicatorRow;
        anchors {
            horizontalCenter: parent.horizontalCenter;
            bottom: parent.bottom; bottomMargin: platformStyle.paddingSmall;
        }
        spacing: platformStyle.paddingSmall;
        visible: dataReady;
        Repeater {
            model: horiView.count;
            Rectangle {
                width: platformStyle.paddingLarge;
                height: platformStyle.paddingLarge;
                border {
                    width: 1;
                    color: platformStyle.colorDisabledMid;
                }
                radius: width / 2;
                color: horiView.currentIndex == index ? "#66ccff" : "transparent";
            }
        }
    }
}
