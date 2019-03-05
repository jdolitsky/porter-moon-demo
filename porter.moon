-- porter.moon 🌜💫

import getenv from require("os")
import MyCloudApp from require("lib/mycloudapp")

-- Version of this bundle
version = "0.1.1"

-- General configuration. Modify for your own registry. This pushes the
-- invocation image to Docker Hub account/org based on the USER env var.
-- Note: the "porterdemo" repo must first be created via Docker Hub UI.
config = {
    meta: {
        name: "my-cloud-app"
        version: version
        description: "️right up to the cloud️"
    }
    registry: {
        host: "docker.io",
        repo: getenv("USER").."/porterdemo"
        tag: version.."-develop"
    }
}

export bundle = MyCloudApp(config).bundle
