import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    id: root;

    property alias title: label.text;

    width: screen.width;
    height: privateStyle.tabBarHeightPortrait;

    Label {
        id: label;
        anchors {
            left: parent.left; leftMargin: platformStyle.paddingLarge;
            right: parent.right;
            verticalCenter: parent.verticalCenter;
        }
        font.pixelSize: platformStyle.fontSizeLarge+4;
    }

    Rectangle {
        anchors {
            left: parent.left; leftMargin: platformStyle.paddingLarge;
            right: parent.right; rightMargin: platformStyle.paddingLarge;
            bottom: parent.bottom; bottomMargin: platformStyle.paddingSmall;
        }
        height: 1;
        color: platformStyle.colorDisabledMid;
    }
}
