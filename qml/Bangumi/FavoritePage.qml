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
                var parse = function(value){
                    var weekdays = ["一","二","三","四","五","六","日"];
                    var subject = value.subject;
                    var prop = {
                        id: subject.id,
                        name: subject.name_cn,
                        progress_string: value.ep_status + "/" + subject.eps,
                        progress_value: Math.min(Math.max(value.ep_status / subject.eps, 0), 1),
                        day: "星期"+weekdays[subject.air_weekday-1],
                        image_grid: subject.images.grid,
                        watching_count: subject.collection.doing
                    }
                    listModel.append(prop);
                    collections.push(subject.id);
                }
                list.forEach(parse);
                signalCenter.collections = collections;
            }
        }
        core().api(url, true, null, get, callback);
    }

    ListView {
        id: view;
        anchors.fill: parent;
        pressDelay: 100;
        model: ListModel {
            id: listModel;
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
                text: "放映日："+day;
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
}
