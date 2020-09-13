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
                    if (!controlButtons.presentationOn) {
                        imageFileDialog.open()
                    }
                }
            }
            LoadButton {
                text: "<font color='#FFFFFF'>" + "Load folder" + "</font>"
                onClicked: {
                    if (!controlButtons.presentationOn) {
                        folderFileDialog.open()
                    }
                }
            }
            LoadButton {
                text: "<font color='#FFFFFF'>" + "Presentation" + "</font>"
                onClicked: {
                    presentationButtons.visible = !presentationButtons.visible
                    timer.toggleIsRunning()
                    controlButtons.presentationOn = !controlButtons.presentationOn
                    runButton.palette.button = "indianred"
                    runButton.isRunning = false
                    remaining.text = "<font color='#FFFFFF'>" + 3 + "</font>"
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
                id: runButton
                text: "<font color='#FFFFFF'>" + "Running" + "</font>"
                property bool isRunning: false
                palette.button: "indianred"
                onClicked: {
                    if(!isRunning){
                        isRunning = true;
                        timer.startTimer(imageNameTable.rowCount);
                        remainingTime.running = true;
                        palette.button = "green";
                    }
                    else{
                        isRunning = false;
                        timer.pauseTimer();
                        remainingTime.running = false;
                        palette.button = "indianred";
                    }
                }
            }
            LoadButton {
                id: remaining
                property real interval: 3
                property real timeRemaining: 3
                text: "<font color='#FFFFFF'>" + interval + "</font>"
                Timer {
                    id: remainingTime
                    interval: 100
                    running: false
                    repeat: true
                    onTriggered: {
                        remaining.text = "<font color='#FFFFFF'>" + "Remaining: " + Math.round(timer.remainingTime()*10)/10 + "</font>"
                    }
                }
            }
            LoadButton{
                TextField {
                    height: parent.height
                    width: 5*parent.width/6
                    placeholderText: qsTr("Set Interval:")
                    validator: IntValidator {bottom: 1; top: 1000}
                    Keys.onReturnPressed: {
                        timer.startTimer(imageNameTable.rowCount, parseInt(text), true)
                        remaining.interval = parseInt(text)
                        text = ""
                        runButton.isRunning = true
                        runButton.palette.button = "green"
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
            id: nameCol
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
        height: 15
        anchors.horizontalCenter: imagePane.horizontalCenter; anchors.top: buttonPanel.bottom
        width: imagePane.width/2
        Text {
            id: imageName
            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "white"
            font.pixelSize: 12
            text: "Name:"
        }
        Text {
            id: imageDate
            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "white"
            font.pixelSize: 12
            text: "Date:"
        }

    }

    Rectangle {
        id: imagePane
        anchors.left: imageNameTable.right; anchors.right: parent.right
        anchors.top: imageTitle.bottom;
        height: parent.height - presentationButtons.height - 55
        anchors.margins: 15
        color: "black"
        clip: true
        Image {
            id: image
            width: parent.width
            height: parent.height
            fillMode: Image.PreserveAspectFit
            //actual image is loaded from list via index provided by coresponding button - not using file name
            source: "image://provider/foo"
            cache: false
            //how scaled the image is
            property real scaleFactor: 1
            property int scaledImageWidth: 0
            property int scaledImageHeight: 0
            //the furthest y coor from origin until first zoom out
            property int maxY: 0
            property int maxX: 0
            //source needs to be reloaded once it is changed on backend
            property bool sourceSwitch: true
            //to not update maxs when moving to the origin
            property bool toOrigin: false
            function reload() {
                if (sourceSwitch) {
                    sourceSwitch = false
                    source = "image://provider/foobar"
                }
                else {
                    sourceSwitch = true
                    source = "image://provider/foo"
                }
                imageName.text = imgDatabase.getImageName()
                image.scaledImageWidth = imgDatabase.scaledImgWidth(image.width, image.height);
                image.scaledImageHeight = imgDatabase.scaledImgHeight(image.width, image.height);
            }
            onWidthChanged: {
                image.scaledImageWidth = imgDatabase.scaledImgWidth(image.width, image.height);

            }
            onHeightChanged: {
                image.scaledImageHeight = imgDatabase.scaledImgHeight(image.width, image.height);
            }
            onXChanged: {
                if (!toOrigin){
                maxX = x
                }
            }
            onYChanged: {
                if (!toOrigin) {
                    maxY = y
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
            drag.target: image
            drag.maximumX: 0
            drag.minimumX: 0
            drag.minimumY: 0
            drag.maximumY: 0
            onWheel: {
                var delta = wheel.angleDelta.y / 120.0
                imagePane.zoom(delta, image)
            }

        }
        function zoom(delta, target) {
            // positive delta zoom in, negative delta zoom out
            var scaleFactor = 0.9
            if (delta > 0) {
                scaleFactor = 1.0/scaleFactor;
            }
            //limit max and min zoom
            if (image.scaleFactor*scaleFactor > 0.2 && image.scaleFactor*scaleFactor < 10) {
                target.scale *= scaleFactor;
                image.scaleFactor *= scaleFactor;
                if (delta > 0) {
                    image.maxX = image.x
                    image.maxY = image.y
                }
            }
            calculateMaxDrag();
            fixZoomOutPos();

        }
        //ensures that image will fill imagePane while possible during zooming out
        function fixZoomOutPos() {
            if (Math.sign(image.y) == -1) {
                if (image.y < dragArea.drag.minimumY){
                    image.y = dragArea.drag.minimumY
                }
            }
            else{
                if (image.y > dragArea.drag.maximumY) {
                    image.y = dragArea.drag.maximumY
                }
            }
            if (Math.sign(image.x) == -1) {
                if (image.x < dragArea.drag.minimumX){
                    image.x = dragArea.drag.minimumX
                }
            }
            else{
                if (image.x > dragArea.drag.maximumX) {
                    image.x = dragArea.drag.maximumX
                }
            }
        }
        //calculates the furthest distance image can be dragged so it still fills the image pane
        function calculateMaxDrag() {
            if (image.scaledImageHeight*image.scaleFactor - imagePane.height > 0) {
                dragArea.drag.maximumY = (image.scaledImageHeight*image.scaleFactor - imagePane.height)/2;
                dragArea.drag.minimumY = -(image.scaledImageHeight*image.scaleFactor - imagePane.height)/2;
            }
            else {
                dragArea.drag.maximumY = 0;
                dragArea.drag.minimumY = 0;
            }
            if (image.scaledImageWidth*image.scaleFactor - imagePane.width > 0) {
                dragArea.drag.maximumX = (image.scaledImageWidth*image.scaleFactor - imagePane.width)/2;
                dragArea.drag.minimumX = -(image.scaledImageWidth*image.scaleFactor - imagePane.width)/2;
            }
            else {
                dragArea.drag.maximumX = 0;
                dragArea.drag.minimumX = 0;
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
    RotateButtons{
        id: rotateButtons
        width: imagePane.width/2
        anchors.horizontalCenter: imagePane.horizontalCenter; anchors.bottom: parent.bottom
        anchors.top: imagePane.bottom
    }

}
