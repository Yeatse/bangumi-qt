import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    id: root;

    width: horiView.width;
    height: horiView.height;

    function loadDetail(obj){
        cmtModel.clear();
        if (Array.isArray(obj.topic)){
            var parse = function (value){
                var name = "", avatar = "";
                if (value.user != null){
                    name = value.user.nickname||value.user.username;
                    if (value.user.avatar != null){
                        avatar = value.user.avatar.medium;
                    }
                }

                var prop = {
                    id: value.id,
                    name: name,
                    avatar: avatar,
                    title: value.title,
                    lastpost: utility.easyDate(new Date(Number(value.lastpost+"000"))),
                    url: value.url
                }

                cmtModel.append(prop);
            }
            obj.topic.forEach(parse);
        }
    }

    SubjectHeader {
        id: viewHeader;
        title: "讨论";
    }

    ListView {
        id: view;
        anchors {
            fill: parent; topMargin: viewHeader.height;
        }
        pressDelay: 150;
        clip: true;
        model: ListModel { id: cmtModel; }
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
                width: 48;
                height: 48;
                sourceSize: "48x48";
                source: avatar;
                Image {
                    anchors.centerIn: parent;
                    sourceSize: "48x48";
                    source: "../gfx/placeholder.png";
                    visible: logo.status != Image.Ready;
                }
            }

            Label {
                id: titleLabel;
                anchors {
                    left: logo.right;
                    leftMargin: platformStyle.paddingMedium;
                    right: listItem.paddingItem.right;
                    top: listItem.paddingItem.top;
                }
                wrapMode: Text.WrapAnywhere;
                text: title;
            }

            ListItemText {
                anchors {
                    left: titleLabel.left;
                    bottom: listItem.paddingItem.bottom;
                }
                role: "SubTitle";
                text: name;
            }

            ListItemText {
                anchors {
                    right: listItem.paddingItem.right;
                    bottom: listItem.paddingItem.bottom;
                }
                role: "SubTitle";
                text: "上次回应:"+lastpost;
            }
        }
    }

    ScrollDecorator {
        flickableItem: view;
    }
}
