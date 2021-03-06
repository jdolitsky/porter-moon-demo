-- base.moon

-- App is a base class that represents a Porter-based application
class App
    new: (conf) =>
        @bundle = {
            name:            conf.meta.name
            version:         conf.meta.version
            description:     conf.meta.description
            invocationImage: conf.registry.host.."/"..conf.registry.repo..":"..conf.registry.tag
            mixins:          {}
            install:         {}
            upgrade:         {}
            uninstall:       {}
            credentials:     {}
        }

    add_mixin: (mixin) =>
        table.insert(@bundle.mixins, mixin)

    add_credentials: (name, path) =>
        table.insert(@bundle.credentials, {name: name, path: path})

    add_install_step: (step) =>
        table.insert(@bundle.install, step)

    add_upgrade_step: (step) =>
        table.insert(@bundle.upgrade, step)

    add_uninstall_step: (step) =>
        table.insert(@bundle.uninstall, step)

return {
    App: App
}
