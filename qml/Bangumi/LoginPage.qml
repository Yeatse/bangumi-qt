import QtQuick 1.1
import com.nokia.symbian 1.1

MyPage {
    id: page;

    function login(){
        unField.text = unField.text.replace(/(^\s*)|(\s*$)/g,"");
        pwField.text = pwField.text.replace(/(^\s*)|(\s*$)/g,"");
        if (unField.text == "" || pwField.text == ""){
            signalCenter.showMessage("用户名和密码不能为空");
        } else {
            var callback = function (resp){
                loading = false;
                if (resp.status == 200){
                    core().saveAuth();
                    pageStack.pop(mainPage);
                    signalCenter.showMessage("欢迎回到Bangumi~");
                    signalCenter.loginFinished();
                } else {
                    signalCenter.showMessage("登录失败> <");
                }
            }
            loading = true;
            core().authenticate(unField.text, pwField.text, callback);
        }
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back";
            onClicked: Qt.quit();
        }
    }

    Flickable {
        id: view;
        anchors.fill: parent;
        contentWidth: parent.width;
        contentHeight: contentCol.height + platformStyle.paddingLarge*2;

        Column {
            id: contentCol;
            anchors {
                left: parent.left; leftMargin: platformStyle.paddingMedium*2;
                right: parent.right; rightMargin: platformStyle.paddingMedium*2;
                top: parent.top; topMargin: platformStyle.paddingLarge;
            }
            spacing: platformStyle.paddingLarge;

            Row {
                spacing: platformStyle.paddingLarge;
                height: platformStyle.graphicSizeLarge;
                Image {
                    source: "gfx/logo.png";
                    anchors.verticalCenter: parent.verticalCenter;
                }
                Label {
                    font.pixelSize: platformStyle.fontSizeLarge+4;
                    anchors.verticalCenter: parent.verticalCenter;
                    text: "登录至Bangumi";
                }
            }

            ListItemText {
                role: "SubTitle";
                text: "你的用户名或邮箱";
            }
            TextField {
                id: unField;
                width: parent.width;
                inputMethodHints: Qt.ImhNoAutoUppercase;
                enabled: !loading;
            }
            ListItemText {
                role: "SubTitle";
                text: "你的密码";
            }
            TextField {
                id: pwField;
                width: parent.width;
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText;
                echoMode: TextInput.Password;
                enabled: !loading;
            }
            Item {  // place holder
                width: 1;
                height: 1;
            }
            Button {
                width: parent.width *3/4;
                anchors.horizontalCenter: parent.horizontalCenter;
                text: "登录";
                enabled: !loading;
                onClicked: login();
            }
            Item {  // place holder
                width: 1;
                height: 1;
            }
            ListItemText {
                anchors.horizontalCenter: parent.horizontalCenter;
                role: "SubTitle";
                text: "还没有Bangumi账户？"
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter;
                text: "<a href='w'>立即注册</a>";
                onLinkActivated: Qt.openUrlExternally("http://bgm.tv/signup");
            }
        }
    }

    Image {
        id: banner;
        anchors {
            left: parent.left; bottom: parent.bottom; right: parent.right;
        }
        source: "gfx/bg_musume.png";
        fillMode: Image.PreserveAspectFit;
    }
}
