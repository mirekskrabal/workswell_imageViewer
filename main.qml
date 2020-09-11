import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Layouts 1.14
import Qt.labs.platform 1.1
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.3
import QtQuick.Controls 2.14
import QtQuick.Controls.Styles 1.4

Window {
    id: imageViewerWindow
    width: 640
    height: 480
    visible: true
    title: qsTr("Image Viewer")
    color: "#3a4055"
    minimumWidth: 640
    minimumHeight: 480
    Rectangle{
        id: buttonPanel
        height: 30
        anchors.left: parent.left; anchors.top: parent.top; anchors.right: parent.right
        visible: true
        color: "dimgrey"
        RowLayout {
            id: controlButtons
            anchors.left: parent.left; anchors.top: parent.top; anchors.right: parent.horizontalCenter
            anchors.bottom: parent.bottom
            spacing: 0
            property bool presentationOn: false
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
                    controlButtons.presentationOn = !controlButtons.presentationOn
                }
            }
        }
        RowLayout {
            id: presentationButtons
            visible: false
            anchors.left: controlButtons.right; anchors.top: parent.top; anchors.right: parent.right
            anchors.bottom: parent.bottom
            spacing: 0
            LoadButton {
                text: "<font color='#FFFFFF'>" + "Start" + "</font>"
                onClicked: {
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
                    height: parent.height
                    placeholderText: qsTr("Set Interval:")
                    validator: IntValidator {bottom: 1; top: 1000}
                    Keys.onReturnPressed: {
                        timer.startTimer(imageNameTable.rowCount, parseInt(text), true)
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
        width: 202
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
            onClicked: {
                contextMenu.popup()
            }
        }

        style: TableViewStyle {
            headerDelegate: Rectangle {
                height: textItem.implicitHeight * 1.2
                width: textItem.implicitWidth
                color: "lightsteelblue"
                Text {
                    id: textItem
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: styleData.textAlignment
                    anchors.leftMargin: 12
                    text: styleData.value
                    elide: Text.ElideRight
                    color: textColor
                    renderType: Text.NativeRendering
                }
                Rectangle {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 1
                    anchors.topMargin: 1
                    width: 1
                    color: "#ccc"
                }
            }
        }
        TableViewColumn {
            role: "str"
            title: "Image Name:"
            width: 160
            delegate: LoadButton {
                width: parent.width
                text: modelData.name
                palette {
                    button: "white"
                }
                onClicked: {
                    if (!controlButtons.presentationOn) {
                        imgDatabase.setIndex(styleData.row)
                        imageName.text = imgDatabase.getImageName()
                    }
                }
            }
        }
        TableViewColumn {
            role: "closeButton"
            title: "Del"
            width: 40
            delegate: LoadButton {
                text: "x"
                palette {
                    button: "white"
                }
                onClicked: {
                    if (!controlButtons.presentationOn) {
                        imgDatabase.deleteImage(styleData.row)
                        imageName.text = imgDatabase.getImageName()
                    }
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
    RowLayout {
        id: imageTitle
        height: 40
        anchors.horizontalCenter: imagePane.horizontalCenter; anchors.top: buttonPanel
        width: imagePane.width/2
        Text {
            id: imageName
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "Name"
        }
        Text {
            id: imageDate
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "Date"
        }

    }

    Rectangle {
        id: imagePane
        anchors.left: imageNameTable.right; anchors.right: parent.right
        anchors.top: imageTitle.bottom;
        height: parent.height - presentationButtons.height - 50
        anchors.margins: 15
        color: "black"
        clip: true
        Image {
            id: image
            width: parent.width
            height: parent.height
//            anchors.margins: 2
            fillMode: Image.PreserveAspectFit
            //actual image is loaded from list via index provided by coresponding button - not using file name
            source: "image://provider/foo"
            cache: false
            //source needs to be reloaded once it is changed on backend
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
                    image.reload()
                }
            }
        }
        MouseArea {
            id: dragArea
            hoverEnabled: true
            anchors.fill: parent
            onWheel: {
                var delta = wheel.angleDelta.y / 120.0
                imagePane.zoom(delta, image)
            }
        }
        function zoom(delta, target) {
            // positive delta zoom in, negative delta zoom out
            var zoomFactor = 0.8
            if (delta > 0) {
                zoomFactor = 1.0/zoomFactor;
            }
            // Zoom the target
            target.scale = target.scale * zoomFactor;
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
    RotateButtons{
        id: rotateButtons
        width: imagePane.width/2
        anchors.horizontalCenter: imagePane.horizontalCenter; anchors.bottom: parent.bottom
        anchors.top: imagePane.bottom
    }

}
