# porter-moon-demo 

<img align="right" src="https://raw.githubusercontent.com/jdolitsky/moopo/master/moopo.png" width="80x" />

## Overview

This is a simple POC of authoring a [Porter](https://porter.sh/) bundle with [MoonScript](https://moonscript.org/).

The deploys an instance of [HackMD](https://github.com/hackmdio/codimd) (CodiMD) using the [Helm mixin](https://github.com/deislabs/porter-helm), backed by an [Azure Database for PostgreSQL](https://azure.microsoft.com/en-us/services/postgresql/) created using the [Azure mixin](https://github.com/deislabs/porter-azure).
## porter.moon

The file [`porter.moon`](./porter.moon) in this repo contains the bundle definition:

```moon
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
```

The `MyCloudApp` class (defined [here](./lib/mycloudapp.moon)) defines the all the different mixins, credentials, and actions for the bundle. 

This is the resulting `porter.yaml` after conversion from MoonScript/Lua:
```yaml
credentials:
- name: kubeconfig
  path: /root/.kube/config
description: ️takes us up to the cloud️, the moon even
install:
- azure:
    description: Install azure postgres db "my-cloud-app-hackmd" (in eastus)
    name: my-cloud-app-hackmd
    parameters:
      administratorLogin: myadminuser
      administratorLoginPassword: myAdminPass123!
      databaseName: hackmd
      location: eastus
      serverName: my-cloud-app-hackmd
    resourceGroup: my-cloud-app-hackmd
    type: postgres
- helm:
    chart: stable/hackmd
    description: Install helm release "my-cloud-app-hackmd" (stable/hackmd 1.1.0)
    name: my-cloud-app-hackmd
    replace: true
    set:
      persistence.enabled: false
      postgresql.install: false
      postgresql.postgresDatabase: hackmd
      postgresql.postgresHost: my-cloud-app-hackmd.postgres.database.azure.com
      postgresql.postgresPassword: myAdminPass123!
      postgresql.postgresUser: myadminuser@my-cloud-app-hackmd.postgres.database.azure.com
      replicaCount: 2
      sessionSecret: abcde12345
    version: 1.1.0
invocationImage: docker.io/jdolitsky/my-cloud-app:0.1.3-develop
mixins:
- azure
- helm
name: my-cloud-app
uninstall:
- helm:
    description: Uninstall helm release "my-cloud-app-hackmd" (stable/hackmd 1.1.0)
    purge: true
    releases:
    - my-cloud-app-hackmd
upgrade:
- helm:
    chart: stable/hackmd
    description: Upgrade helm release "my-cloud-app-hackmd" (stable/hackmd 1.1.0)
    name: my-cloud-app-hackmd
    set:
      persistence.enabled: false
      postgresql.install: false
      postgresql.postgresDatabase: hackmd
      postgresql.postgresHost: my-cloud-app-hackmd.postgres.database.azure.com
      postgresql.postgresPassword: myAdminPass123!
      postgresql.postgresUser: myadminuser@my-cloud-app-hackmd.postgres.database.azure.com
      replicaCount: 2
      sessionSecret: abcde12345
    version: 1.1.0
version: 0.1.3
```

## How to use

The following commands can be run in the root of this repo after installing [moopo](https://github.com/jdolitsky/moopo) (a space-age Porter pre-processor that converts `porter.moon` into `porter.yaml`).

### Install bundle

```
$ moopo run --action=install
[moopo] Converting porter.moon to porter.lua... Done.
[moopo] Converting porter.lua to porter.yaml... Done.
executing porter install configuration from porter.yaml
Install azure postgres db "my-cloud-app-hackmd" (in eastus)
Starting deployment operations...
...
```

### Upgrade bundle
```
$ moopo run --action=upgrade
[moopo] Converting porter.moon to porter.lua... Done.
[moopo] Converting porter.lua to porter.yaml... Done.
executing porter upgrade configuration from porter.yaml
Upgrade helm release "my-cloud-app-hackmd" (stable/hackmd 1.1.0)
...
```

### Uninstall bundle
```
$ moopo run --action=uninstall
[moopo] Converting porter.moon to porter.lua... Done.
[moopo] Converting porter.lua to porter.yaml... Done.
executing porter uninstall configuration from porter.yaml
Uninstall helm release "my-cloud-app-hackmd" (stable/hackmd 1.1.0)
...
```

### Build and push bundle

Run this in an environment that is allowed to push the invocation image.

```
$ moopo build
[moopo] Converting porter.moon to porter.lua... Done.
[moopo] Converting porter.lua to porter.yaml... Done.
Copying dependencies ===>
Copying mixins ===>
...
```
