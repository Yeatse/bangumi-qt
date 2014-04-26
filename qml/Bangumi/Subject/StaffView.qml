import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    id: root;

    width: horiView.width;
    height: horiView.height;

    function loadDetail(obj){
        stfModel.clear();
        if (Array.isArray(obj.staff)){
            var parse = function (value){
                var imageGrid = "";
                if (value.images != null){
                    imageGrid = value.images.grid;
                }
                var jobs = "";
                if (Array.isArray(value.jobs)){
                    jobs = value.jobs.join(",");
                }

                var prop = {
                    id: value.id,
                    image_grid: imageGrid,
                    name: value.name,
                    name_cn: value.name_cn,
                    jobs: jobs,
                    url: value.url
                }
                stfModel.append(prop);
            }
            obj.staff.forEach(parse);
        }
    }

    SubjectHeader {
        id: viewHeader;
        title: "STAFF";
    }

    ListView {
        id: view;
        anchors {
            fill: parent; topMargin: viewHeader.height;
        }
        pressDelay: 150;
        clip: true;
        model: ListModel { id: stfModel; }
        delegate: AbstractItem {
            id: listItem;
            implicitHeight: 96;
            onClicked: signalCenter.enterUrl(url);

            Image {
                id: logo;
                anchors {
                    left: listItem.paddingItem.left;
                    top: listItem.paddingItem.top;
                }
                width: 75;
                height: 75;
                sourceSize: "75x75";
                source: image_grid;
                Image {
                    anchors.centerIn: parent;
                    sourceSize: "75x75";
                    source: "../gfx/placeholder.png";
                    visible: logo.status != Image.Ready;
                }
            }

            ListItemText {
                id: nameLabel;
                anchors {
                    left: logo.right;
                    leftMargin: platformStyle.paddingMedium;
                    top: listItem.paddingItem.top;
                }
                role: "SubTitle";
                text: name;
            }

            ListItemText {
                anchors {
                    left: nameLabel.left;
                    top: nameLabel.bottom;
                }
                text: name_cn||name;
            }

            ListItemText {
                anchors {
                    left: nameLabel.left;
                    bottom: listItem.paddingItem.bottom;
                }
                role: "SubTitle";
                text: jobs;
            }
        }
    }

    ScrollDecorator {
        flickableItem: view;
    }
}
