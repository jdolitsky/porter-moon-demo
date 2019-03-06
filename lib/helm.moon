-- helm.moon

-- HelmRelease is a class for working with Helm releases that plugs into the Helm mixin
class HelmRelease
    _format: (o) => {helm: o}

    new: (@name, @chart, @version) =>
        @values = {}

    set_values: (values) =>
        @values = values

    install: =>
        @_format({
            description: "Install helm release \""..@name.."\" ("..@chart.." "..@version..")"
            name:        @name
            chart:       @chart
            version:     @version
            set:         @values
            replace:     true
        })

    upgrade: =>
        @_format({
            description: "Upgrade helm release \""..@name.."\" ("..@chart.." "..@version..")"
            name:        @name
            chart:       @chart
            version:     @version
            set:         @values
        })

    uninstall: =>
        @_format({
            description: "Uninstall helm release \""..@name.."\" ("..@chart.." "..@version..")"
            releases:    {@name}
            purge:       true
        })

return {
    HelmRelease: HelmRelease
}
