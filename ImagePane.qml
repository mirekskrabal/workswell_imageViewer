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
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
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
