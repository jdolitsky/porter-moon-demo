# porter-moon-demo 

<img align="right" src="https://raw.githubusercontent.com/jdolitsky/moopo/master/moopo.png" width="80x" />

## Overview

This is a simple POC of authoring a [Porter](https://porter.sh/) bundle with [MoonScript](https://moonscript.org/).

The application first launches an [Azure SQL](https://azure.microsoft.com/en-us/services/sql-database/) database, then deploys an instance of [HackMD](https://github.com/hackmdio/codimd) (CodiMD) using the db.

## porter.moon

The file [`porter.moon`](./porter.moon) in this repo contains the bundle definition:

```moon
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
```

The `MyCloudApp` class (defined [here](./lib/mycloudapp.moon)) defines the all the different mixins, credentials, and actions for the bundle. 

This is the resulting `porter.yaml` after conversion from MoonScript:
```yaml
credentials:
- name: kubeconfig
  path: /root/.kube/config
description: ️right up to the cloud️
install:
- helm:
    chart: stable/hackmd
    description: Install helm release "my-cloud-app-hackmd" (stable/hackmd 1.0.1)
    name: my-cloud-app-hackmd
    replace: true
    version: 1.0.1
invocationImage: docker.io/jdolitsky/porterdemo:0.1.1-develop
mixins:
- helm
name: my-cloud-app
uninstall:
- helm:
    description: Uninstall helm release "my-cloud-app-hackmd" (stable/hackmd 1.0.1)
    purge: true
    releases:
    - my-cloud-app-hackmd
upgrade:
- helm:
    chart: stable/hackmd
    description: Upgrade helm release "my-cloud-app-hackmd" (stable/hackmd 1.0.1)
    name: my-cloud-app-hackmd
    version: 1.0.1
version: 0.1.1
```

## How to use

The following commands can be run in the root of this repo after installing [moopo](https://github.com/jdolitsky/moopo) (a space-age Porter pre-processor that converts `porter.moon` into `porter.yaml`).

### Build bundle

Run this in an environment that is allowed to push the invocation image.

```
$ moopo build
Built ./porter.moon
Built ./lib/base.moon
Built ./lib/helm.moon
Built ./lib/mycloudapp.moon
Copying dependencies ===>
Copying mixins ===>
Copying mixin helm ===>
Copying mixin porter ===>

Generating Dockerfile =======>
FROM quay.io/deis/lightweight-docker-go:v0.2.0
...
```

### Install bundle

```
$ moopo run --action=install
Built ./porter.moon
Built ./lib/base.moon
Built ./lib/helm.moon
Built ./lib/mycloudapp.moon
executing porter install configuration from porter.yaml
Install helm release "my-cloud-app-hackmd" (stable/hackmd 1.0.1)
/usr/local/bin/helm helm install --name my-cloud-app-hackmd stable/hackmd --version 1.0.1 --replace
NAME:   my-cloud-app-hackmd
LAST DEPLOYED: Tue Mar  5 04:59:12 2019
NAMESPACE: default
STATUS: DEPLOYED
...
```

### Upgrade bundle
```
$ moopo run --action=upgrade
Built ./porter.moon
Built ./lib/base.moon
Built ./lib/helm.moon
Built ./lib/mycloudapp.moon
executing porter upgrade configuration from porter.yaml
Upgrade helm release "my-cloud-app-hackmd" (stable/hackmd 1.0.1)
/usr/local/bin/helm helm upgrade my-cloud-app-hackmd stable/hackmd --version 1.0.1
Release "my-cloud-app-hackmd" has been upgraded. Happy Helming!
...
```

### Uninstall bundle
```
$ moopo run --action=uninstall
Built ./porter.moon
Built ./lib/base.moon
Built ./lib/helm.moon
Built ./lib/mycloudapp.moon
executing porter uninstall configuration from porter.yaml
Uninstall helm release "my-cloud-app-hackmd" (stable/hackmd 1.0.1)
/usr/local/bin/helm helm delete --purge my-cloud-app-hackmd
release "my-cloud-app-hackmd" deleted
execution completed successfully!
```
