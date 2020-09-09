import QtQuick 2.0
import QtQuick.Dialogs 1.3


Item {
    FileDialog {
        nameFilters: ["(*.jpg)"]
        selectMultiple: true
        folder: shortcuts.home
        onAccepted: imgLoader.appendImage(fileUrls)

    }
}
