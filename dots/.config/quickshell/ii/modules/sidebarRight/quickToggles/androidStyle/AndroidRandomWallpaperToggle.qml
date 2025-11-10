import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import Quickshell
import Quickshell.Io

AndroidQuickToggleButton {
    id: root

    name: Translation.tr("Random Wallpaper")
    statusText: toggled ? Translation.tr("On boot") : Translation.tr("Disabled")

    toggled: false
    buttonIcon: "wallpaper"

    onClicked: {
        root.toggled = !root.toggled
        if (root.toggled) {
            Quickshell.execDetached(["bash", "-c", "sed -i '8s/^#//' ~/.config/hypr/custom/execs.conf"])
        } else {
            Quickshell.execDetached(["bash", "-c", "sed -i '8s/^/#/' ~/.config/hypr/custom/execs.conf"])
        }
    }

    Process {
        id: fetchActiveState
        running: true
        command: ["bash", "-c", "~/.config/hypr/custom/scripts/check_random_wallpaper.sh"]
        stdout: StdioCollector {
            id: statusCollector
            onStreamFinished: {
                if (statusCollector.text.trim() === "enabled") {
                    root.toggled = true
                } else {
                    root.toggled = false
                }
            }
        }
    }

    StyledToolTip {
        text: Translation.tr("Random wallpaper on boot")
    }
}
