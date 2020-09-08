import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Layouts 1.14
import QtQuick.Controls 2.3
import Qt.labs.platform 1.1
import QtQuick.Controls 1.4


Window {
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
                    fileDialog.open()
                }
            }

            LoadButton {
                text: "<font color='#FFFFFF'>" + "Load folder" + "</font>"
            }

        }

        TableView{
            id: imageButtons;
            anchors.left: parent.left; anchors.top: loadButtons.bottom; anchors.right: parent.right
            anchors.margins: 2
            clip: true
            TableViewColumn {

            }
            TableViewColumn {

            }
            model: libraryModel

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
        id: fileDialog
        currentFile: document.source
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
    }

}
