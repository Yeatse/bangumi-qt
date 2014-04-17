import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    id: root;

    width: horiView.width;
    height: horiView.height;

    function loadDetail(obj){
        episodeModel.clear();
        if (Array.isArray(obj.eps)){
            var parse = function (value){
                var prop = {
                    airdate: value.airdate,
                    id: value.id,
                    name: value.name,
                    name_cn: value.name_cn,
                    sort: value.sort,
                    play_status: value.status,
                    view_status_id: 0,
                    view_status_name: "",
                    url: value.url
                }
                episodeModel.append(prop);
            }
            obj.eps.forEach(parse);
        }
    }

    SubjectHeader {
        id: viewHeader;
        title: "剧集";
    }

    ListView {
        id: view;
        anchors {
            fill: parent; topMargin: viewHeader.height;
        }
        clip: true;
        model: episodeModel;
        delegate: AbstractItem {
            id: listItem;
            onClicked: Qt.openUrlExternally(url);
            Column {
                anchors {
                    left: listItem.paddingItem.left;
                    right: listItem.paddingItem.right;
                    verticalCenter: parent.verticalCenter;
                }
                ListItemText {
                    role: "SubTitle";
                    text: "ep."+sort+"  "+name;
                }
                ListItemText {
                    text: name_cn||name||" ";
                }
                ListItemText {
                    role: "SubTitle";
                    anchors.right: parent.right;
                    text: airdate||" ";
                }
            }
        }
    }

    ScrollBar {
        anchors { right: view.right; top: view.top; }
        flickableItem: view;
    }
}
