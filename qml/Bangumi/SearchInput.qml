import QtQuick 1.1
import com.nokia.symbian 1.1

TextField {
    id: root;

    signal typeStopped;
    signal cleared;

    onTextChanged: {
        inputTimer.restart();
    }

    platformLeftMargin: searchIcon.width + platformStyle.paddingMedium;
    platformRightMargin: clearButton.width + platformStyle.paddingMedium;

    Timer {
        id: inputTimer;
        interval: 500;
        onTriggered: root.typeStopped();
    }

    Image {
        id: searchIcon;
        anchors { left: parent.left; leftMargin: platformStyle.paddingMedium; verticalCenter: parent.verticalCenter; }
        width: platformStyle.graphicSizeSmall;
        height: platformStyle.graphicSizeSmall;
        sourceSize.width: platformStyle.graphicSizeSmall;
        sourceSize.height: platformStyle.graphicSizeSmall;
        source: privateStyle.imagePath("qtg_graf_search_indicator", root.platformInverted);
    }

    Item {
        id: clearButton;
        anchors { right: parent.right; rightMargin: platformStyle.paddingMedium; verticalCenter: parent.verticalCenter; }
        height: platformStyle.graphicSizeSmall;
        width: platformStyle.graphicSizeSmall;
        visible: root.activeFocus;
        Image {
            anchors.fill: parent;
            sourceSize: Qt.size(platformStyle.graphicSizeSmall, platformStyle.graphicSizeSmall);
            source: privateStyle.imagePath(clearMouseArea.pressed?"qtg_graf_textfield_clear_pressed":"qtg_graf_textfield_clear_normal",
                                                                   root.platformInverted);
        }
        MouseArea {
            id: clearMouseArea;
            anchors.fill: parent;
            onClicked: {
                root.closeSoftwareInputPanel();
                root.text = "";
                root.cleared();
                root.parent.forceActiveFocus();
            }
        }
    }
}
