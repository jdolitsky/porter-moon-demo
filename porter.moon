name = "my-bundle"
version = "0.1.0"
description = "this application is extremely important"

-- Example of pushing to your personal Docker Hub account,
-- assuming USER env var matches your Docker Hub username
-- (make sure you create the "my-bundle" repo ahead of time)
registry_host = "docker.io"
registry_repo = os.getenv("USER").."/"..name

-- Class that represents our app
class MyApp
    new: =>
        @bundle = {
            name: name,
            version: version,
            description: description,
            invocationImage: registry_host.."/"..registry_repo..":"..version,
            mixins: {},
            install: {},
            uninstall: {}
            credentials: {
                {
                    name: "kubeconfig",
                    path: "/root/.kube/config"
                }
            }
        }

    add_mixin: (mixin) =>
        table.insert(@bundle.mixins, mixin)

    add_install_step: (step) =>
        table.insert(@bundle.install, step)

    add_uninstall_step: (step) =>
        table.insert(@bundle.uninstall, step)

-- Method that returns valid input for helm mixin
helm_release = (c) ->
    {helm: c}

-- Create bundle and modify
app = MyApp!
app\add_mixin("helm")

release_name = "porter-hackmd-demo"

app\add_install_step(helm_release{
    description: "Install hackmd ("..release_name..")",
    name: release_name,
    chart: "stable/hackmd",
    version: "1.0.1",
    replace: true
})

app\add_uninstall_step(helm_release{
    description: "Uninstall hackmd ("..release_name..")",
    name: release_name
})

-- Export bundle
export bundle = app.bundle