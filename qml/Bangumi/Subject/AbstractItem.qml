import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    id: root;

    property alias paddingItem: paddingItem;

    signal clicked;
    signal pressAndHold;

    implicitWidth: screen.width;
    implicitHeight: platformStyle.graphicSizeLarge;

    opacity: (ListView.isCurrentItem
              && symbian.listInteractionMode == Symbian.KeyNavigation)
             ||mouseArea.pressed ? 0.7 : 1;

    Item {
        id: paddingItem;
        anchors {
            left: parent.left; leftMargin: platformStyle.paddingLarge;
            right: parent.right; rightMargin: platformStyle.paddingLarge;
            top: parent.top; topMargin: platformStyle.paddingLarge;
            bottom: parent.bottom; bottomMargin: platformStyle.paddingLarge;
        }
    }

    Rectangle {
        id: bottomLine;
        anchors {
            left: root.left; right: root.right; bottom: parent.bottom;
        }
        height: 1;
        color: platformStyle.colorDisabledMid;
    }

    MouseArea {
        id: mouseArea;
        anchors.fill: parent;
        enabled: root.enabled;
        onClicked: {
            if (root.ListView.view)
                root.ListView.view.currentIndex = index;
            root.clicked();
        }
        onPressed: {
            symbian.listInteractionMode = Symbian.TouchInteraction;
            privateStyle.play(Symbian.BasicItem);
        }
        onReleased: {
            privateStyle.play(Symbian.BasicItem);
        }
        onPressAndHold: {
            root.pressAndHold();
        }
    }

    Keys.onPressed: {
        if (!event.isAutoRepeat) {
            switch (event.key) {
                case Qt.Key_Select:
                case Qt.Key_Enter:
                case Qt.Key_Return: {
                    if (symbian.listInteractionMode != Symbian.KeyNavigation)
                        symbian.listInteractionMode = Symbian.KeyNavigation
                    else if (root.enabled)
                        root.clicked()
                    event.accepted = true
                    break
                }
                case Qt.Key_Up: {
                    if (symbian.listInteractionMode != Symbian.KeyNavigation) {
                        symbian.listInteractionMode = Symbian.KeyNavigation
                        ListView.view.positionViewAtIndex(index, ListView.Beginning)
                    } else
                        ListView.view.decrementCurrentIndex()
                    event.accepted = true
                    break
                }
                case Qt.Key_Down: {
                    if (symbian.listInteractionMode != Symbian.KeyNavigation) {
                        symbian.listInteractionMode = Symbian.KeyNavigation
                        ListView.view.positionViewAtIndex(index, ListView.Beginning)
                    } else
                        ListView.view.incrementCurrentIndex()
                    event.accepted = true
                    break
                }
                default: {
                    event.accepted = false
                    break
                }
            }
        }
        if (event.key == Qt.Key_Up || event.key == Qt.Key_Down)
            symbian.privateListItemKeyNavigation(ListView.view)
    }

    NumberAnimation {
        id: onAddAnimation
        target: root
        property: "opacity"
        duration: 250
        from: 0.25; to: 1;
    }

    ListView.onAdd: {
        onAddAnimation.start();
    }
}
