import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Layouts 1.14
import QtQuick.Controls 2.3
import Qt.labs.platform 1.1
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.3
import QtQuick.Controls 2.14


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
                    timer.toggleIsRunning()
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
                    console.log("number of rows from qml: " + imageNameTable.rowCount)
                    timer.startTimer(imageNameTable.rowCount)
                }
            }
            LoadButton {
                text: "<font color='#FFFFFF'>" + "Stop" + "</font>"
                onClicked: {
                    timer.pauseTimer();
                }
            }
            LoadButton{
                TextField {
                    id: txtInput
                    width: 3*parent.width/5
                    anchors.verticalCenter: parent.verticalCenter
                    placeholderText: qsTr("Time(s):")
                    validator: IntValidator {bottom: 1; top: 1000}
                    Keys.onReturnPressed: {
                        timer.startTimer(imageNameTable.rowCount, parseInt(text))
                        text = ""
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
            title: "Image Name:"
            width: 170
            delegate: LoadButton {
                width: parent.width
                text: modelData.name
                onClicked: {
                    imgDatabase.setIndex(styleData.row)
                }
            }
        }
        TableViewColumn {
            role: "closeButton"
            title: "Del"
            width: 20
            delegate: LoadButton {
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
                imageNameTable.model = imgDatabase.images
            }
        }
    }

    Rectangle {
        id: imagePane
        anchors.left: imageNameTable.right; anchors.right: parent.right
        anchors.top: buttonPanel.bottom; anchors.bottom: parent.bottom
        height: parent.height - presentationButtons.height - 50
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
            property bool sourceSwitch: true
            function reload() {
                if (sourceSwitch) {
                    sourceSwitch = false
                    source = "image://provider/foobar"
                }
                else {
                    sourceSwitch = true
                    source = "image://provider/foo"
                }
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
    RowLayout {
        id: rotateButtons
        width: imagePane.width/2
        anchors.horizontalCenter: imagePane.horizontalCenter; anchors.bottom: parent.bottom
        anchors.top: imagePane.bottom
        spacing: 0
        RoundButton {
            text: "<font color='#FFFFFF'>" + "Left" + "</font>"
            radius: 5
            onClicked: {
                imgDatabase.rotateLeft()
                displayedImage.reload()
            }
        }
        RoundButton {
            text: "<font color='#FFFFFF'>" + "Right" + "</font>"
            radius: 5
            onClicked: {
                imgDatabase.rotateRight()
                displayedImage.reload()
            }
        }
    }
}
