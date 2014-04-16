import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: page;
    property bool loading: false;
    orientationLock: PageOrientation.LockPortrait;

    BusyIndicator {
        anchors.centerIn: parent;
        z: 10;
        width: platformStyle.graphicSizeLarge;
        height: platformStyle.graphicSizeLarge;
        running: loading;
        visible: loading;
    }
}
