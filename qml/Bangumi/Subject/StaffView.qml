import QtQuick 1.1

Item {
    id: root;

    width: horiView.width;
    height: horiView.height;

    SubjectHeader {
        id: viewHeader;
        title: "STAFF";
    }

    ListView {
        id: view;
        anchors {
            fill: parent; topMargin: viewHeader.height;
        }
        clip: true;
        model: ListModel { id: stfModel; }
        delegate: AbstractItem {
            id: listItem;
        }
    }
}
