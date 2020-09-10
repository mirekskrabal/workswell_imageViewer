import QtQuick 2.14
import QtQuick.Layouts 1.14
import QtQuick.Controls 2.3

RowLayout {
    id: rowLayout
    anchors.margins: 4
    spacing: 15
    RoundButton {
        Layout.fillWidth: true
        Layout.fillHeight: true
        text: "<font color='#FFFFFF'>" + "Left" + "</font>"
        radius: 9
        palette {
            button: "dimgray"
        }
        onClicked: {
            imgDatabase.rotateLeft()
            image.reload()
        }
    }
    RoundButton {
        Layout.fillWidth: true
        Layout.fillHeight: true
        text: "<font color='#FFFFFF'>" + "Right" + "</font>"
        display: AbstractButton.TextBesideIcon
        radius: 9
        palette {
            button: "dimgray"
        }
        onClicked: {
            imgDatabase.rotateRight()
            image.reload()
        }
    }
}
