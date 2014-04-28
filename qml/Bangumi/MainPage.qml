import QtQuick 1.1
import com.nokia.symbian 1.1

MyPage {
    id: mainPage;

    property alias collectionBox: cBox;

    title: tabGroup.currentTab.title;

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back";
            onClicked: {
                if (quitTimer.running){
                    Qt.quit();
                } else {
                    signalCenter.showMessage("再按一次退出程序");
                    quitTimer.start();
                }
            }
            Timer {
                id: quitTimer;
                interval: infoBanner.timeout;
            }
        }
        ToolButton {
            iconSource: "toolbar-refresh";
            onClicked: {
                var tab = tabGroup.currentTab;
                if (tab && typeof(tab.getlist) == "function"){
                    tab.getlist();
                }
            }
        }
        ToolButton {
            iconSource: "toolbar-search";
            onClicked: {
                pageStack.push(Qt.resolvedUrl("SearchPage.qml"))
            }
        }
        ToolButton {
            iconSource: "toolbar-menu";
            onClicked: mainMenu.open();
        }
    }

    Connections {
        target: signalCenter;
        onRequestLogin: {
            tabChangeListener.target = null;
        }
        onLoginFinished: {
            tabChangeListener.target = tabGroup;
            if (tabGroup.currentTab){
                tabGroup.currentTab.initialize();
            }
        }
    }

    Connections {
        id: tabChangeListener;
        target: null;
        onCurrentTabChanged: {
            if (tabGroup.currentTab){
                tabGroup.currentTab.initialize();
            }
        }
    }

    CollectionBox {
        id: cBox;
    }

    TabBar {
        id: tabBar;
        z: tabGroup.z + 1;
        TabButton {
            iconSource: "gfx/favourite.png";
            tab: favPage;
        }
        TabButton {
            iconSource: "gfx/calendar.png";
            tab: cldPage;
        }
        TabButton {
            iconSource: "gfx/content.png";
            tab: cntPage;
        }
    }

    TabGroup {
        id: tabGroup;
        anchors {
            fill: parent; topMargin: tabBar.height;
        }
        currentTab: favPage;
        FavoritePage {
            id: favPage;
            pageStack: mainPage.pageStack;
        }
        CalendarPage {
            id: cldPage;
            pageStack: mainPage.pageStack;
        }
        ContentPage {
            id: cntPage;
            pageStack: mainPage.pageStack;
        }
    }

    Menu {
        id: mainMenu;
        MenuLayout {
            MenuItem {
                property variant aboutDialog: null;
                text: "关于";
                onClicked: {
                    if (!aboutDialog){
                        aboutDialog = Qt.createComponent("AboutDialog.qml").createObject(mainPage);
                    }
                    aboutDialog.open();
                }
            }
            MenuItem {
                text: "登出";
                onClicked: {
                    core().clearAuth(true);
                    signalCenter.requestLogin();
                }
            }
        }
    }
}
