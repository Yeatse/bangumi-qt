import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1

MyPage {
    id: page;

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back";
            onClicked: pageStack.pop();
        }
    }

    SearchBox {
        id: searchBox;
    }
}
