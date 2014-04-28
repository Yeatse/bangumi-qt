import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import "../js/api.bgm.js" as Api

PageStackWindow {
    id: app;

    function core(){
        return Api.Core;
    }

    showStatusBar: true;
    showToolBar: true;
    platformSoftwareInputPanelEnabled: true;

    initialPage: MainPage {
        id: mainPage;
    }

    QtObject {
        id: signalCenter;

        property variant collections: [];

        signal requestLogin;
        onRequestLogin: {
            pageStack.push(Qt.resolvedUrl("LoginPage.qml"));
        }

        signal loginFinished;

        function showMessage(msg){
            if (msg||false){
                infoBanner.text = msg;
                infoBanner.open();
            }
        }

        function isCollected(id){
            return collections.indexOf(id) >= 0;
        }

        function createCollectBox(id, name){
            var c = mainPage.collectionBox;
            c.sid = id;
            c.titleText = name;
            c.getDetail();
            c.open();
        }

        function enterUrl(url){
            pageStack.push(Qt.resolvedUrl("WebPage.qml"), { url: url });
        }
    }

    StatusPaneText {
        id: statusPaneText;
    }

    InfoBanner {
        id: infoBanner;
        iconSource: "gfx/error.svg";
    }

    Component.onCompleted: {
        if (core().loadAuth()){
            signalCenter.loginFinished();
        } else {
            signalCenter.requestLogin();
        }
    }
}
