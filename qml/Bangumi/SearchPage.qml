import QtQuick 1.1
import com.nokia.symbian 1.1

MyPage {
    id: page;

    property string searchText: "";
    property int totalCount: 0;

    function getlist(option){
        if (searchText == ""){
            searchModel.clear();
            return;
        }
        loading = true;
        var url = "/search/subject/"+searchText;
        var get = { "start": 0, "max_results": 20, "responseGroup": "medium" };
        if (option == "next"){
            get.start = searchModel.count;
        }
        var callback = function (obj){
            loading = false;
            totalCount = 0;
            if (option != "next") searchModel.clear();
            if (obj != null && Array.isArray(obj.list)){
                totalCount = obj.results;
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
                        image_grid: imageGrid
                    }
                    searchModel.append(prop);
                }
                obj.list.forEach(parse);
            }
        }
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
        }
        Button {
            id: searchButton;
            anchors {
                right: parent.right; rightMargin: platformStyle.paddingMedium;
                verticalCenter: parent.verticalCenter;
            }
            text: "搜索";
            platformInverted: true;
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
            id: root;
            implicitHeight: 96;
            onClicked: pageStack.push(Qt.resolvedUrl("SubjectPage.qml"), { sid: model.id })

            Image {
                id: logo;
                anchors {
                    left: root.paddingItem.left;
                    top: root.paddingItem.top;
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
                    top: root.paddingItem.top;
                }
                role: "SubTitle";
                text: name;
            }

            ListItemText {
                anchors {
                    left: jpname.left;
                    top: jpname.bottom;
                }
                text: name_cn;
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
