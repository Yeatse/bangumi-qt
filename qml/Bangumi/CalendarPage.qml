import QtQuick 1.1
import com.nokia.symbian 1.1

MyPage {
    id: page;

    property variant itemList: [];

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
                var resultArray = [];
                var parseItem = function(value){
                    var prop = {
                        id: value.id,
                        name: value.name,
                        name_cn: value.name_cn || value.name,
                        image_grid: value.images.grid,
                        watching_count: value.collection.doing,
                        air_date: value.air_date,
                        air_weekday: value.air_weekday,
                        collected: signalCenter.isCollected(value.id)
                    }
                    resultArray.push(prop);
                }
                var parseDay = function(value){
                    if (Array.isArray(value.items)){
                        value.items.forEach(parseItem);
                    }
                }
                list.forEach(parseDay);
                itemList = resultArray;
                weekdaySelector.selectedIndex = new Date().getDay() - 1;
                weekdaySelector.accepted();
            }
        }
        core().api(url, true, null, {}, callback);
    }

    title: "每日放送";

    ListHeading {
        id: listHeading;
        z: view.z + 1;
        ListItemText {
            id: listHeadingText;
            anchors.fill: parent.paddingItem;
            role: "Heading";
        }
    }

    ListView {
        id: view;
        anchors {
            fill: parent; topMargin: listHeading.height;
        }
        pressDelay: 50;
        model: ListModel {
            id: listModel;
        }
        delegate: ListItem {
            id: root;
            implicitHeight: 96;
            onPressAndHold: signalCenter.createCollectBox(model.id, name_cn);

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
                text: "首映日期："+air_date;
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

    Button {
        anchors { left: parent.left; bottom: parent.bottom; margins: platformStyle.paddingMedium; }
        width: height;
        iconSource: privateStyle.toolBarIconPath("toolbar-list");
        onClicked: weekdaySelector.open();
    }

    SelectionDialog {
        id: weekdaySelector;
        titleText: "选择放映日期";
        model: ["星期一","星期二","星期三","星期四","星期五","星期六","星期日"];
        onAccepted: {
            listHeadingText.text = model[selectedIndex];
            var parse = function(value){
                if (value.air_weekday == selectedIndex + 1){
                    listModel.append(value);
                }
            }
            listModel.clear();
            itemList.forEach(parse);
        }
    }

    ScrollDecorator {
        flickableItem: view;
    }
}
