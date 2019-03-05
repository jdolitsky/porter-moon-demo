-- Class that represents a Porter-based application
class App
    new: =>
        @bundle = {
            name: "",
            version: "",
            description: "",
            invocationImage: "",
            mixins: {},
            install: {},
            uninstall: {},
            credentials: {}
        }

    set_name: (name) =>
        @bundle.name = name

    set_version: (version) =>
        @bundle.version = version

    set_description: (description) =>
        @bundle.description = description

    set_image: (host, repo, tag) =>
        @bundle.invocationImage = host.."/"..repo..":"..tag

    add_mixin: (mixin) =>
        table.insert(@bundle.mixins, mixin)

    add_credentials: (name, path) =>
        table.insert(@bundle.credentials, {name: name, path: path})

    add_install_step: (step) =>
        table.insert(@bundle.install, step)

    add_uninstall_step: (step) =>
        table.insert(@bundle.uninstall, step)

return {
    App: App
}