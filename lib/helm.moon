-- Class for working with Helm releases that works with Helm mixin
class HelmRelease
    _mixin_format: (params) => {helm: params}

    new: (@name, @chart, @version) =>

    install: =>
        @_mixin_format({
            description: "Install "..@name.." ("..@chart.." version "..@version..")",
            name: @name,
            chart: @chart,
            version: @version
            replace: true
        })

    upgrade: =>
        @_mixin_format({
            description: "Upgrade "..@name.." ("..@chart.." version "..@version..")",
            name: @name,
            chart: @chart,
            version: @version
        })

    uninstall: =>
        @_mixin_format({
            description: "Uninstall "..@name.." ("..@chart.." version "..@version..")",
            releases: {@name},
            purge: true
        })

return {
    HelmRelease: HelmRelease
}
