pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services
import qs.utils

ColumnLayout {
    id: root

    property string view: "wireless" // "wireless" or "ethernet"

    spacing: Tokens.spacing.small
    width: Tokens.sizes.bar.networkWidth

    // ── Wireless ──────────────────────────────────────────────────────────

    RowLayout {
        visible: root.view === "wireless"
        Layout.topMargin: Tokens.padding.normal
        Layout.rightMargin: Tokens.padding.small
        spacing: Tokens.spacing.normal

        MaterialIcon {
            text: {
                if (!NetworkBackend.wifiEnabled)
                    return "wifi_off";
                if (NetworkBackend.active)
                    return Icons.getNetworkIcon(NetworkBackend.active.strength ?? 0);
                return "wifi_off";
            }
            color: NetworkBackend.active ? Colours.palette.m3primary : Colours.palette.m3onSurfaceVariant
        }

        ColumnLayout {
            spacing: 0

            StyledText {
                text: {
                    if (!NetworkBackend.wifiEnabled)
                        return qsTr("WiFi disabled");
                    return NetworkBackend.active?.ssid ?? qsTr("Not connected");
                }
                font.weight: NetworkBackend.active ? 500 : 400
                color: NetworkBackend.active ? Colours.palette.m3onSurface : Colours.palette.m3onSurfaceVariant
            }

            StyledText {
                visible: NetworkBackend.wifiEnabled && NetworkBackend.active !== null
                text: qsTr("Connected")
                color: Colours.palette.m3primary
                font.pointSize: Tokens.font.size.small
            }
        }
    }

    // Separator — only shown when detail rows follow
    Rectangle {
        visible: root.view === "wireless" && NetworkBackend.active !== null
        Layout.fillWidth: true
        Layout.rightMargin: Tokens.padding.small
        Layout.topMargin: Tokens.spacing.small
        implicitHeight: 1
        color: Colours.palette.m3outlineVariant
        opacity: 0.4
    }

    InfoRow {
        visible: root.view === "wireless" && (NetworkBackend.active?.ipv4Address.length ?? 0) > 0
        label: qsTr("IP")
        value: NetworkBackend.active?.ipv4Address ?? ""
    }

    InfoRow {
        visible: root.view === "wireless" && NetworkBackend.active !== null
        label: qsTr("Security")
        value: {
            const sec = NetworkBackend.active?.security ?? "";
            return sec.length > 0 ? sec : qsTr("Open");
        }
    }

    InfoRow {
        visible: root.view === "wireless" && NetworkBackend.active !== null
        label: qsTr("Signal")
        value: qsTr("%1%").arg(NetworkBackend.active?.strength ?? 0)
    }

    Item {
        visible: root.view === "wireless"
        Layout.preferredHeight: Tokens.padding.normal
    }

    // ── Ethernet ──────────────────────────────────────────────────────────

    RowLayout {
        visible: root.view === "ethernet"
        Layout.topMargin: Tokens.padding.normal
        Layout.rightMargin: Tokens.padding.small
        spacing: Tokens.spacing.normal

        MaterialIcon {
            text: "cable"
            color: NetworkBackend.activeEthernet ? Colours.palette.m3primary : Colours.palette.m3onSurfaceVariant
        }

        ColumnLayout {
            spacing: 0

            StyledText {
                text: NetworkBackend.activeEthernet?.interface ?? qsTr("Not connected")
                font.weight: NetworkBackend.activeEthernet ? 500 : 400
                color: NetworkBackend.activeEthernet ? Colours.palette.m3onSurface : Colours.palette.m3onSurfaceVariant
            }

            StyledText {
                visible: NetworkBackend.activeEthernet !== null
                text: qsTr("Connected")
                color: Colours.palette.m3primary
                font.pointSize: Tokens.font.size.small
            }
        }
    }

    Item {
        visible: root.view === "ethernet"
        Layout.preferredHeight: Tokens.padding.normal
    }

    // ── Shared row component ───────────────────────────────────────────────

    component InfoRow: RowLayout {
        id: infoRow

        required property string label
        required property string value

        Layout.fillWidth: true
        Layout.rightMargin: Tokens.padding.small
        spacing: Tokens.spacing.small

        StyledText {
            text: infoRow.label
            color: Colours.palette.m3onSurfaceVariant
            font.pointSize: Tokens.font.size.small
        }

        Item {
            Layout.fillWidth: true
        }

        StyledText {
            text: infoRow.value
            font.weight: 500
            horizontalAlignment: Text.AlignRight
        }
    }
}
