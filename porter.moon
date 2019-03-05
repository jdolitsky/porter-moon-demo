-- porter.moon 🌜💫

import MyCloudApp from require("lib/mycloudapp")

name = "my-cloud-app"
version = "0.1.3"
description = "️takes us up to the cloud️, the moon even"

-- General configuration. Modify for your own registry. This pushes the
-- invocation image to Docker Hub account/org based on the USER env var.
-- Note: the "my-cloud-app" repo must first be created via Docker Hub UI.
config = {
    meta: {:name, :version, :description}
    registry: {
        host: "docker.io",
        repo: os.getenv("USER").."/"..name
        tag: version.."-develop"
    }
}

export bundle = MyCloudApp(config).bundle
