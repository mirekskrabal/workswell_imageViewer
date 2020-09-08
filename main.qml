import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Layouts 1.14
import QtQuick.Controls 2.3
import Qt.labs.platform 1.1
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.3



Window {
    id: imageViewerWindow
    width: 640
    height: 480
    visible: true
    title: qsTr("Image Viewer")
    color: "grey"
    Rectangle{
        id: buttonPanel
        anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom
        anchors.margins: 15
        width: 200
        visible: true
        border.color: "black"
        border.width: 1
        color: "darkgrey"
        RowLayout {
            id: loadButtons
            anchors.left: parent.left; anchors.top: parent.top; anchors.right: parent.right
            width: 200
            height: 30
            anchors.margins: 5
            LoadButton {
                text: "<font color='#FFFFFF'>" + "Load img" + "</font>"
                onClicked: {
                    imageFileDialog.open()
                }
            }

            LoadButton {
                text: "<font color='#FFFFFF'>" + "Load folder" + "</font>"
                onClicked: {
                    folderFileDialog.open()
                }
            }

        }

        TableView {
            id: imageButtons;
            anchors.left: parent.left; anchors.top: loadButtons.bottom; anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 3
            clip: true
            TableViewColumn {
                role: "str"
                title: "Image"
                width: 170
                delegate: Text {
                    width: parent.width
                    text: modelData.name
                }
            }
            TableViewColumn {
                role: "closeButton"
                title: ""
                width: 20
                delegate: Button {
                    text: "del"
                    onClicked: {
                        imgLoader.deleteImage(styleData.row)
                    }
                }
            }
            model: imgLoader.images
            Connections {
                target: imgLoader
                function onImagesChanged(){
                    imageButtons.model = imgLoader.images
                }
            }
        }
    }
    Rectangle {
        id: imagePane
        anchors.left: buttonPanel.right; anchors.right: parent.right; anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 15
        border.color: "black"
        border.width: 1
        color: "darkgrey"
    }

    FileDialog {
        id: imageFileDialog
        nameFilters: ["(*.jpg)"]
        selectMultiple: true
        folder: shortcuts.home
        onAccepted: imgLoader.appendImage(fileUrls)

    }
    FileDialog {
        id: folderFileDialog
        selectFolder: true
        selectMultiple: true
        folder: shortcuts.home
        onAccepted: imgLoader.searchFolder(folder)
    }


}
