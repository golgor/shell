import QtQuick
import QtQuick.Layouts
import Caelestia
import Caelestia.Config
import qs.components
import qs.services

Item {
    id: root

    required property real dashboardOffsetScale
    required property bool fullscreen

    readonly property real offsetScale: fullscreen || !Config.dashboard.enabled ? 1 : 1 - dashboardOffsetScale

    visible: !fullscreen && Config.dashboard.enabled && offsetScale < 1
    anchors.topMargin: (-implicitHeight - 5) * offsetScale
    implicitWidth: row.implicitWidth + Tokens.padding.large * 2
    implicitHeight: row.implicitHeight + Tokens.padding.normal * 2
    opacity: 1 - offsetScale

    Behavior on implicitWidth {
        Anim {}
    }

    RowLayout {
        id: row

        anchors.centerIn: parent
        spacing: Tokens.spacing.normal

        StyledText {
            id: dateText

            text: Time.format("dddd d MMMM yyyy")
            font.family: Tokens.font.family.sans
            font.pointSize: Tokens.font.size.smaller
            color: Colours.palette.m3onSurface
        }

        StyledText {
            text: "·"
            font.family: Tokens.font.family.sans
            font.pointSize: Tokens.font.size.smaller
            color: Colours.palette.m3onSurface
        }

        StyledText {
            text: "W" + CUtils.isoWeekNumber(Time.date)
            font.family: Tokens.font.family.sans
            font.pointSize: Tokens.font.size.smaller
            color: Colours.palette.m3onSurface
        }

        StyledText {
            text: "|"
            font.family: Tokens.font.family.sans
            font.pointSize: Tokens.font.size.smaller
            color: Colours.palette.m3onSurface
            opacity: 0.5
        }

        StyledText {
            text: Time.format(GlobalConfig.services.useTwelveHourClock ? "hh:mm A" : "hh:mm")
            font.family: Tokens.font.family.mono
            font.pointSize: Tokens.font.size.smaller
            font.weight: 600
            color: Colours.palette.m3onSurface
        }
    }
}
