pragma ComponentBehavior: Bound

import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services

ColumnLayout {
    id: root

    property string view: "wireless" // "wireless" or "ethernet"

    spacing: Tokens.spacing.small

    // ── Wireless ──────────────────────────────────────────────────────────

    StyledText {
        visible: root.view === "wireless"
        text: qsTr("WiFi: %1").arg(!NetworkBackend.wifiEnabled ? qsTr("Disabled") : NetworkBackend.active ? qsTr("Connected") : qsTr("Not connected"))
    }

    StyledText {
        visible: root.view === "wireless" && NetworkBackend.active !== null
        text: qsTr("SSID: %1").arg(NetworkBackend.active?.ssid ?? "")
    }

    StyledText {
        visible: root.view === "wireless" && (NetworkBackend.active?.ipv4Address.length ?? 0) > 0
        text: qsTr("IP: %1").arg(NetworkBackend.active?.ipv4Address ?? "")
    }

    StyledText {
        visible: root.view === "wireless" && NetworkBackend.active !== null
        text: {
            const sec = NetworkBackend.active?.security ?? "";
            return qsTr("Security: %1").arg(sec.length > 0 ? sec : qsTr("Open"));
        }
    }

    StyledText {
        visible: root.view === "wireless" && NetworkBackend.active !== null
        text: qsTr("Signal: %1%").arg(NetworkBackend.active?.strength ?? 0)
    }

    // ── Ethernet ──────────────────────────────────────────────────────────

    StyledText {
        visible: root.view === "ethernet"
        text: qsTr("Ethernet: %1").arg(NetworkBackend.activeEthernet ? qsTr("Connected") : qsTr("Not connected"))
    }

    StyledText {
        visible: root.view === "ethernet" && NetworkBackend.activeEthernet !== null
        text: qsTr("Interface: %1").arg(NetworkBackend.activeEthernet?.interface ?? "")
    }
}
