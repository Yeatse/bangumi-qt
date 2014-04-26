import QtQuick 1.1
import com.nokia.symbian 1.1
import QtWebKit 1.0

MyPage {
    id: page;

    property alias url: webView.url;

    title: webView.title;

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back";
            onClicked: pageStack.pop();
        }
    }

    FlickableWebView {
        id: webView;
        anchors.fill: parent;
    }

    ScrollDecorator {
        flickableItem: webView;
    }

    ProgressBar {
        id: proBar;
        anchors {
            left: parent.left; right: parent.right;
            bottom: parent.bottom;
        }
        opacity: 0.6;
        visible: webView.loading;
        value: webView.progress;
    }
}
