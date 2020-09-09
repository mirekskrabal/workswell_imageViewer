import QtQuick 2.14
import QtQuick.Controls 1.4

TableView {
    id: imageButtons;
    anchors.left: parent.left; anchors.top: loadButtons.bottom; anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.margins: 3
    clip: true
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: {
            contextMenu.popup()
        }
    }
    TableViewColumn {
        role: "str"
        title: "Image"
        width: 170
        delegate: Button {
            width: parent.width
            text: modelData.name
            onClicked: {
//                        console.log("image should be loaded" + styleData.row);
                imgDatabase.createImage(styleData.row)
            }
        }
    }
    TableViewColumn {
        role: "closeButton"
        title: ""
        width: 20
        delegate: Button {
            text: "del"
            onClicked: {
                imgDatabase.deleteImage(styleData.row)
            }
        }
    }
    model: imgDatabase.images
    Connections {
        target: imgDatabase
        function onImagesChanged(){
            imageButtons.model = imgDatabase.images
        }
    }
}
