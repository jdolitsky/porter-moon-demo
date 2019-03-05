-- Base class that represents a Porter-based application
class App
    new: (meta) =>
        @bundle = {
            name: meta.name,
            version: meta.version,
            description: meta.description,
            invocationImage: "",
            mixins: {},
            install: {},
            upgrade: {},
            uninstall: {},
            credentials: {}
        }

    set_image: (image) =>
        @bundle.invocationImage = image

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
