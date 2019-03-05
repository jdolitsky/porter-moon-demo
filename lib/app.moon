-- Base class that represents a Porter-based application
class App
    new: (name, version, description, image) =>
        @bundle = {
            name: name,
            version: version,
            description: description,
            invocationImage: image,
            mixins: {},
            install: {},
            upgrade: {},
            uninstall: {},
            credentials: {}
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
