import QtQuick 1.1
import com.nokia.symbian 1.1

CommonDialog {
    id: root;

    titleText: "关于";

    content: Column {
        width: parent.width;
        spacing: platformStyle.paddingLarge;
        Item { width: 1; height: 1; }
        ListItemText {
            anchors.horizontalCenter: parent.horizontalCenter;
            text: "Bangumi For Qt";
        }
        ListItemText {
            anchors.horizontalCenter: parent.horizontalCenter;
            role: "SubTitle";
            text: "Version "+utility.appVersion;
        }
        ListItemText {
            anchors.horizontalCenter: parent.horizontalCenter;
            role: "SubTitle";
            text: "Designed By Yeatse"
        }
        Item { width: 1; height: 1; }
    }

    buttonTexts: ["确定"];
}
