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

        ImageNameList {}
    }
    ImagePane {}

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
