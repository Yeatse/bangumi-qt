import QtQuick 1.1
import com.nokia.symbian 1.1

MyPage {
    id: page;

    property bool firstStart: true;
    function initialize(){
        if (firstStart){
            firstStart = false;
            getlist();
        }
    }

    function getlist(){
        loading = true;
        var url = "/user/"+core().getUID()+"/collection";
        var get = { "cat": "watching" };
        var callback = function(list){
            loading = false;
            if (Array.isArray(list)){
                listModel.clear();
                var collections = [];
                var weekdays = ["一","二","三","四","五","六","日"];
                var todayId = (new Date().getDay()+6)%7+1;
                var i = 0;

                var parse = function(value, today){
                    var subject = value.subject;
                    var imageGrid = "";
                    if (subject.images != null){
                        imageGrid = subject.images.grid;
                    }
                    var progValue = subject.eps == 0 ? 0.5 : Math.min(Math.max(value.ep_status / subject.eps, 0), 1);
                    var prop = {
                        id: subject.id,
                        name: subject.name_cn||subject.name,
                        progress_string: value.ep_status + "/" + (subject.eps||"???"),
                        progress_value: progValue,
                        day: "星期"+weekdays[subject.air_weekday-1],
                        image_grid: imageGrid,
                        watching_count: subject.collection.doing,
                        flag: today ? "星期"+weekdays[todayId-1] : "其它"
                    }
                    listModel.append(prop);
                    collections.push(subject.id);
                }

                for (i in list){
                    if (list[i].subject.air_weekday == todayId){
                        parse(list[i], true);
                    }
                }
                for (i in list){
                    if (list[i].subject.air_weekday != todayId){
                        parse(list[i], false);
                    }
                }

                signalCenter.collections = collections;
                // TODO: ugly hack, will be fixed later
                cldPage.firstStart = true;
            }
        }
        core().api(url, true, null, get, callback);
    }

    title: "收藏列表";

    ListView {
        id: view;
        anchors.fill: parent;
        pressDelay: 50;
        cacheBuffer: view.height;
        model: ListModel {
            id: listModel;
        }
        section {
            property: "flag";
            delegate: ListHeading {
                ListItemText {
                    anchors.fill: parent.paddingItem;
                    text: section;
                    role: "Heading";
                }
            }
        }
        delegate: ListItem {
            id: root;
            implicitHeight: 96;
            onPressAndHold: signalCenter.createCollectBox(model.id, name);
            onClicked: pageStack.push(Qt.resolvedUrl("SubjectPage.qml"), { sid: model.id })

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
                id: title;
                anchors {
                    left: logo.right;
                    leftMargin: platformStyle.paddingMedium;
                    top: root.paddingItem.top;
                }
                role: "Title";
                text: name;
            }

            BProgressBar {
                id: proBar
                anchors {
                    left: title.left;
                    top: title.bottom;
                }
                value: progress_value;
            }

            ListItemText {
                anchors {
                    left: proBar.right;
                    leftMargin: platformStyle.paddingMedium;
                    top: title.bottom;
                }
                role: "SubTitle";
                text: progress_string;
            }

            ListItemText {
                anchors {
                    left: title.left;
                    bottom: root.paddingItem.bottom;
                }
                role: "SubTitle";
                text: "放送星期："+day;
            }

            ListItemText {
                anchors {
                    right: root.paddingItem.right;
                    bottom: root.paddingItem.bottom;
                }
                role: "SubTitle";
                text: watching_count + "人在看";
            }
        }
    }

    ScrollDecorator {
        flickableItem: view;
    }
}
