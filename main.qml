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
        height: 30
        anchors.left: parent.left; anchors.top: parent.top; anchors.right: parent.right
        visible: true
        color: "dimgrey"
        RowLayout {
            id: loadButtons
            anchors.left: parent.left; anchors.top: parent.top; anchors.right: parent.horizontalCenter
            anchors.bottom: parent.bottom
            spacing: 0
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
            LoadButton {
                text: "<font color='#FFFFFF'>" + "Presentation" + "</font>"
                onClicked: {
                    presentationButtons.visible = !presentationButtons.visible
                }
            }
        }
        RowLayout {
            id: presentationButtons
            visible: false
            anchors.left: loadButtons.right; anchors.top: parent.top; anchors.right: parent.right
            anchors.bottom: parent.bottom
            spacing: 0
            LoadButton {
                text: "<font color='#FFFFFF'>" + "Start" + "</font>"
                onClicked: {
                    folderFileDialog.open()
                }
            }
            LoadButton {
                text: "<font color='#FFFFFF'>" + "Stop" + "</font>"
                onClicked: {
                    folderFileDialog.open()
                }
            }
            LoadButton{
                TextField {
                    id: txtInput
                    width: 2*parent.width/5
                    anchors.verticalCenter: parent.verticalCenter
                    placeholderText: qsTr("Time:")
                    Keys.onReturnPressed: {
                    }
                }
            }
        }
    }
    TableView {
        id: imageNameTable
        anchors.left: parent.left; anchors.top: buttonPanel.bottom; anchors.bottom: parent.bottom
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
                    imgDatabase.setIndex(styleData.row)
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

    Rectangle {
        id: imagePane
        anchors.left: imageNameTable.right; anchors.right: parent.right
        anchors.top: buttonPanel.bottom; anchors.bottom: parent.bottom
        anchors.margins: 15
        color: "black"
        Image {
            id: displayedImage
            width: parent.width
            height: parent.height
            anchors.margins: 2
            fillMode: Image.PreserveAspectFit
            //actual image is loaded from list via index provided by coresponding button - not using file name
            source: "image://provider/foo"
            cache: false
            function reload() {
                var oldSource = source;
                source = "";
                source = oldSource;
            }
            Connections {
                target: imgDatabase
                function onIndexChanged() {
                    displayedImage.reload()
                }
            }
        }
    }

    FileDialog {
        id: imageFileDialog
        nameFilters: ["(*.jpg)"]
        selectMultiple: true
        folder: shortcuts.home
        onAccepted: imgDatabase.appendImage(fileUrls)

    }
    FileDialog {
        id: folderFileDialog
        selectFolder: true
        selectMultiple: true
        folder: shortcuts.home
        onAccepted: imgDatabase.searchFolder(folder)
    }
    Menu {
        id: contextMenu
        MenuItem {
            text: qsTr('Delete all');
            onTriggered: imgDatabase.clearImages()
        }
    }

}
