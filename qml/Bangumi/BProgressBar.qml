import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    id: root

    // Common Public API
    property double value: 0.0;

    // Symbian specific API
    property bool platformInverted: false

    implicitWidth: Math.max(50, screen.width / 2) // TODO: use screen.displayWidth
    implicitHeight: privateStyle.sliderThickness

    BorderImage {
        id: background

        source: privateStyle.imagePath("qtg_fr_progressbar_track", root.platformInverted)
        border { left: platformStyle.borderSizeMedium; top: 0; right: platformStyle.borderSizeMedium; bottom: 0 }
        anchors.fill: parent
    }

    Item {
        id: progressMask

        anchors {
            top: parent.top; bottom: parent.bottom; left: parent.left;
        }

        width: root.width * value;
        clip: true

        BorderImage {
            id: progress

            source: privateStyle.imagePath("qtg_fr_progressbar_fill", root.platformInverted)
            border {
                left: platformStyle.borderSizeMedium
                right: platformStyle.borderSizeMedium
                top: 0
                bottom: 0
            }
            height: parent.height
            width: root.width
        }
    }
}
