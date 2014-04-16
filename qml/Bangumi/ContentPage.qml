import QtQuick 1.1
import com.nokia.symbian 1.1
import QtWebKit 1.0

MyPage {
    id: page;

    property bool firstStart: true;
    function initialize(){
        if (firstStart){
            firstStart = false;
            getlist();
        }
    }

    function getlist(){
        var mobileUrl = "http://bgm.tv/m";
        if (webView.url == mobileUrl){
            webView.reload();
        } else {
            webView.url = mobileUrl;
        }
    }

    title: "超展开";

    Flickable {
        id: view;
        anchors.fill: parent;
        contentWidth: webView.width;
        contentHeight: webView.height;
        boundsBehavior: Flickable.StopAtBounds;

        WebView {
            id: webView;
            preferredWidth: view.width;
            preferredHeight: view.height;
            settings {
                minimumFontSize: platformStyle.fontSizeMedium;
                minimumLogicalFontSize: platformStyle.fontSizeMedium;
                defaultFontSize: platformStyle.fontSizeLarge;
                defaultFixedFontSize: platformStyle.fontSizeLarge;
            }
            html: " ";
            onLoadStarted: proBar.visible = true;
            onLoadFinished: proBar.visible = false;
            onLoadFailed: proBar.visible = false;
        }
    }

    ProgressBar {
        id: proBar;
        anchors {
            left: parent.left; right: parent.right;
            bottom: parent.bottom;
        }
        opacity: 0.6;
        visible: false;
        value: webView.progress;
    }
}
