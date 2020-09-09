import QtQuick 2.0

Rectangle {
    id: imagePane
    anchors.left: buttonPanel.right; anchors.right: parent.right; anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.margins: 15
    border.color: "black"
    border.width: 1
    color: "darkgrey"
    Image {
        id: displayedImage
        //actuall file is provided by a signal from image database
        source: "image://provider/something"
        cache: false
        function reload() {
            var oldSource = source;
            source = "";
            source = oldSource;
        }
        Connections {
            target: imgProvider
            function onImageUpdated(){
                console.log("Image was updated")
                displayedImage.reload()
            }
        }
    }
}
