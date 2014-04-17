import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    id: root;

    width: horiView.width;
    height: horiView.height;

    function loadDetail(obj){
        crtModel.clear();
        if (Array.isArray(obj.crt)){
            var parse = function (value){
                var actorlist = [];
                if (Array.isArray(value.actors)){
                    for (var i in value.actors){
                        actorlist.push(value.actors[i].name);
                    }
                }
                var imageGrid = "";
                if (value.images != null){
                    imageGrid = value.images.grid;
                }
                var prop = {
                    actors: actorlist.join(","),
                    image_grid: imageGrid,
                    name: value.name,
                    name_cn: value.name_cn,
                    role_name: value.role_name
                }
                crtModel.append(prop);
            }
            obj.crt.forEach(parse);
        }
    }

    SubjectHeader {
        id: viewHeader;
        title: "出场角色";
    }

    ListView {
        id: view;
        anchors {
            fill: parent; topMargin: viewHeader.height;
        }
        clip: true;
        model: ListModel { id: crtModel; }
        delegate: AbstractItem {
            id: listItem;
            implicitHeight: 96;
            onClicked: Qt.openUrlExternally(url);

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
                text: "CV:"+actors;
            }

            ListItemText {
                anchors {
                    right: listItem.paddingItem.right;
                    bottom: listItem.paddingItem.bottom;
                }
                role: "SubTitle";
                text: role_name;
            }
        }
    }
}
