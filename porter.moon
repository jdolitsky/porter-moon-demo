import helm_release from require "lib/helm"
import App from require "lib/app"

-- App metadata
name = "myapp"
version = "0.1.0"
description = "this application is extremely important"

-- Example of pushing to your personal Docker Hub account,
-- assuming USER env var matches your Docker Hub username
-- (make sure you create the "my-bundle" repo ahead of time)
registry_host = "docker.io"
registry_repo = os.getenv("USER").."/"..name

-- Create app and modify
app = App!
app\set_name(name)
app\set_version(version)
app\set_description(description)
app\set_image(registry_host, registry_repo, version)
app\add_mixin("helm")
app\add_credentials("kubeconfig", "/root/.kube/config")

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
