//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1

import Quickshell

import "modules/bar" as Bar
import "services" as Services
import "styles" as Styles

ShellRoot {
    id: root

    Styles.Theme {
        id: theme
    }

    Services.Audio {
        id: audio
    }

    Services.Battery {
        id: battery
    }

    Services.Network {
        id: network
    }

    Bar.Bar {
        theme: theme
        audio: audio
        battery: battery
        network: network
    }
}
