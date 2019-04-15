-- porter.moon 🌜💫

import DevCluster from require("lib/cluster")

name = "dev-cluster"
version = "0.1.0"
description = "a Kubernetes cluster with several useful apps installed"

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

export bundle = DevCluster(config).bundle
