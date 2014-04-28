import QtQuick 1.1
import com.nokia.symbian 1.1

MyPage {
    id: page;

    property string searchText: "";
    property int pageIndex: 0;
    property bool hasMore: false;

    function getlist(option){
        if (searchText == ""){
            searchModel.clear();
            pageIndex = 0;
            hasMore = false;
            return;
        }
        option = option||"renew";
        var reqPage;
        if (option == "renew"){
            pageIndex = 0;
            reqPage = 0;
        } else {
            reqPage = pageIndex + 1;
        }
        var url = "/search/subject/"+searchText;
        var get = { "start": reqPage*20, "max_results": 20, "responseGroup": "medium" };

        var callback = function (obj){
            loading = false;
            hasMore = false;
            if (option == "renew"){
                searchModel.clear();
            }
            if (obj != null && Array.isArray(obj.list)){
                pageIndex = reqPage;
                hasMore = (reqPage+1)*20 < obj.results;
                var parse = function(value){
                    var imageGrid = "";
                    if (value.images != null){
                        imageGrid = value.images.grid;
                    }
                    var prop = {
                        id: value.id,
                        name: value.name,
                        name_cn: value.name_cn,
                        type: value.type,
                        doing_count: value.collection.doing,
                        collect_count: value.collection.collect,
                        image_grid: imageGrid,
                        url: value.url
                    }
                    searchModel.append(prop);
                }
                obj.list.forEach(parse);
            }
        }
        loading = true;
        core().api(url, false, null, get, callback);
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back";
            onClicked: pageStack.pop();
        }
    }

    Item {
        id: viewHeader;
        width: parent.width;
        height: privateStyle.tabBarHeightPortrait;
        z: view.z + 1;
        BorderImage {
            anchors.fill: parent;
            source: privateStyle.imagePath("qtg_fr_tab_bar");
            border {
                left: platformStyle.borderSizeMedium;
                top: platformStyle.borderSizeMedium;
                right: platformStyle.borderSizeMedium;
                bottom: platformStyle.borderSizeMedium;
            }
        }
        SearchInput {
            id: searchInput;
            anchors {
                left: parent.left; right: searchButton.left;
                margins: platformStyle.paddingMedium;
                verticalCenter: parent.verticalCenter;
            }
            onCleared: getlist();
        }
        Button {
            id: searchButton;
            anchors {
                right: parent.right; rightMargin: platformStyle.paddingMedium;
                verticalCenter: parent.verticalCenter;
            }
            platformInverted: true;
            text: "搜索";
            onClicked: {
                searchText = searchInput.text;
                getlist();
            }
        }
    }

    ListView {
        id: view;
        anchors {
            fill: parent; topMargin: viewHeader.height;
        }
        model: ListModel { id: searchModel; }
        delegate: ListItem {
            id: listItem;
            implicitHeight: 96;
            onClicked: {
                if (type == 2){
                    pageStack.push(Qt.resolvedUrl("SubjectPage.qml"), { sid: model.id });
                } else {
                    signalCenter.enterUrl(url);
                }
            }

            Image {
                id: logo;
                anchors {
                    left: listItem.paddingItem.left;
                    top: listItem.paddingItem.top;
                }
                width: 48;
                height: 48;
                source: image_grid;
                Image {
                    anchors.fill: parent;
                    sourceSize: "48x48";
                    source: "gfx/placeholder.png";
                    visible: logo.status != Image.Ready;
                }
            }

            ListItemText {
                id: jpname;
                anchors {
                    left: logo.right;
                    leftMargin: platformStyle.paddingMedium;
                    top: listItem.paddingItem.top;
                }
                role: "SubTitle";
                text: name;
            }

            ListItemText {
                anchors {
                    left: jpname.left;
                    top: jpname.bottom;
                }
                text: name_cn||name;
            }

            ListItemText {
                anchors {
                    left: jpname.left;
                    bottom: listItem.paddingItem.bottom;
                }
                role: "SubTitle";
                Component.onCompleted: {
                    var typelist = ["书籍","番剧","音乐","游戏","","三次元"];
                    text = typelist[type-1] + "  在看:" + doing_count + "  看过:" + collect_count;
                }
            }
        }
        footer: Item {
            width: screen.width;
            height: platformStyle.graphicSizeLarge;
            visible: view.count > 0;
            Button {
                anchors {
                    left: parent.left; right: parent.right;
                    margins: platformStyle.paddingLarge;
                    verticalCenter: parent.verticalCenter;
                }
                text: "继续加载";
                enabled: !loading && hasMore;
                onClicked: getlist("next");
            }
        }
    }

    onStatusChanged: {
        if (status == PageStatus.Active){
            searchInput.focus = true;
            searchInput.openSoftwareInputPanel();
        }
    }
}
