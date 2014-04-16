import QtQuick 1.1
import com.nokia.symbian 1.1

MyPage {
    id: page;

    property int todayIndex: -1;
    function positionView(){
        if (todayIndex > 0){
            view.positionViewAtIndex(todayIndex, ListView.Beginning);
        }
    }

    property bool firstStart: true;
    function initialize(){
        if (firstStart){
            firstStart = false;
            getlist();
        }
    }

    function getlist(){
        loading = true;
        var url = "/calendar";
        var callback = function(list){
            loading = false;
            if (Array.isArray(list)){
                listModel.clear();
                var weekday = "";
                var parseItem = function(value){
                    var prop = {
                        id: value.id,
                        name: value.name,
                        name_cn: value.name_cn || value.name,
                        image_grid: value.images.grid,
                        watching_count: value.collection.doing,
                        weekday: weekday,
                        air_weekday: value.air_weekday,
                        collected: signalCenter.isCollected(value.id)
                    }
                    listModel.append(prop);
                }
                var parseDay = function(value){
                    if (Array.isArray(value.items)){
                        weekday = value.weekday.cn;
                        value.items.forEach(parseItem);
                    }
                }
                list.forEach(parseDay);

                var today = new Date().getDay();
                for (var i=0; i<listModel.count; i++){
                    if (listModel.get(i).air_weekday == today){
                        todayIndex = i;
                        coldDownTimer.restart();
                        break;
                    }
                }

                if (utility.qtVersion > 0x040800 && scroller.listView == null){
                    scroller.listView = view;
                }
            }
        }
        core().api(url, true, null, {}, callback);
    }

    Timer {
        id: coldDownTimer;
        interval: 250;
        onTriggered: page.positionView();
    }

    ListView {
        id: view;
        anchors.fill: parent;
        pressDelay: 100;
        model: ListModel {
            id: listModel;
        }
        section {
            property: "weekday";
            delegate: ListHeading {
                ListItemText {
                    anchors.fill: parent.paddingItem;
                    role: "Heading";
                    text: section;
                }
            }
        }
        delegate: ListItem {
            id: root;
            implicitHeight: 96;

            Image {
                id: logo;
                anchors {
                    left: root.paddingItem.left;
                    top: root.paddingItem.top;
                }
                width: 48;
                height: 48;
                source: image_grid;
                Image {
                    anchors.fill: parent;
                    sourceSize: "48x48";
                    source: "gfx/placeholder.png";
                    visible: logo.status != Image.Ready;
                }
            }

            ListItemText {
                id: jpname;
                anchors {
                    left: logo.right;
                    leftMargin: platformStyle.paddingMedium;
                    top: root.paddingItem.top;
                }
                role: "SubTitle";
                text: name;
            }

            Image {
                id: favIcon;
                anchors {
                    left: jpname.left; top: jpname.bottom;
                }
                width: platformStyle.graphicSizeSmall;
                height: platformStyle.graphicSizeSmall;
                visible: collected;
                source: collected ? "gfx/star.png" : "";
            }

            ListItemText {
                anchors {
                    left: collected ? favIcon.right : jpname.left;
                    verticalCenter: favIcon.verticalCenter;
                }
                text: name_cn;
            }

            ListItemText {
                anchors {
                    left: jpname.left; bottom: root.paddingItem.bottom;
                }
                role: "SubTitle";
                text: watching_count + "人在看";
            }
        }
    }

    SectionScroller {
        id: scroller;
    }
}
