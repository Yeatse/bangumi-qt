import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    id: root;

    function loadDetail(obj){
        var weekdays = ["一","二","三","四","五","六","日"];
        if (obj.images != null){
            logoImage.source = obj.images.medium;
        }
        nameLabel.text = obj.name;
        namecnLabel.text = obj.name_cn||obj.name;
        page.title = namecnLabel.text;
        airDateText.text = "放送开始："+obj.air_date;
        airWeekText.text = "放送星期：星期"+weekdays[obj.air_weekday-1];
        summaryLabel.text = obj.summary;

        collectionRow.children[0].count = obj.collection.wish;
        collectionRow.children[1].count = obj.collection.collect;
        collectionRow.children[2].count = obj.collection.doing;
        collectionRow.children[3].count = obj.collection.on_hold;
        collectionRow.children[4].count = obj.collection.dropped;
    }

    width: horiView.width;
    height: horiView.height;

    SubjectHeader {
        id: viewHeader;
        title: "简介";
    }

    Image {
        id: logoImage;
        anchors {
            left: parent.left; top: viewHeader.bottom;
            margins: platformStyle.paddingLarge;
        }
        width: 100;
        height: 141;
        sourceSize: "100x141";

        Image {
            anchors.centerIn: parent;
            source: "../gfx/placeholder.png";
            sourceSize: "100x100";
            visible: logoImage.status != Image.Ready;
        }
    }

    Column {
        anchors {
            left: logoImage.right; top: viewHeader.bottom;
            right: parent.right; margins: platformStyle.paddingLarge;
        }
        spacing: platformStyle.paddingMedium;
        Label {
            id: nameLabel;
            width: parent.width;
            wrapMode: Text.Wrap;
            font.pixelSize: platformStyle.fontSizeSmall;
        }
        Label {
            id: namecnLabel;
            width: parent.width;
            wrapMode: Text.Wrap;
            font.pixelSize: platformStyle.fontSizeLarge;
        }
        ListItemText {
            id: airDateText;
            role: "SubTitle";
        }
        ListItemText {
            id: airWeekText;
            role: "SubTitle";
            text: "放送星期";
        }
    }

    Row {
        id: collectionRow;
        anchors {
            top: logoImage.bottom; topMargin: platformStyle.paddingLarge;
            horizontalCenter: parent.horizontalCenter;
        }
        spacing: platformStyle.paddingMedium;
        Repeater {
            model: ["想看","看过","在看","搁置","抛弃"];
            Rectangle {
                property int count: 0;
                width: 60;
                height: 50;
                radius: 3;
                color: "#369cf8";
                Label {
                    y: 5;
                    anchors.horizontalCenter: parent.horizontalCenter;
                    text: modelData;
                }
                Label {
                    anchors {
                        horizontalCenter: parent.horizontalCenter;
                        bottom: parent.bottom;
                        bottomMargin: 5;
                    }
                    font.pixelSize: platformStyle.fontSizeSmall;
                    text: String(parent.count);
                }
            }
        }
    }

    SubjectHeader {
        id: summaryHeader;
        title: "概要";
        anchors.top: collectionRow.bottom;
        visible: summaryLabel.text != "";
    }

    Flickable {
        id: summaryFlickable;
        anchors {
            left: parent.left; top: summaryHeader.bottom;
            right: parent.right; bottom: parent.bottom;
            margins: platformStyle.paddingLarge;
        }
        pressDelay: 150;
        clip: true;
        contentWidth: width;
        contentHeight: summaryLabel.height;
        flickableDirection: Flickable.VerticalFlick;
        Label {
            id: summaryLabel;
            width: parent.width;
            wrapMode: Text.Wrap;
        }
    }

    ScrollDecorator {
        flickableItem: summaryFlickable;
    }
}
