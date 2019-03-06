-- mycloudapp.moon

import App from require("lib/base")
import HelmRelease from require("lib/helm")
import AzurePostgreSQLDatabase from require("lib/azure")

-- component-specific settings
settings = {
    hackmd: {
        replicas: 2
        chart: {
            ref:     "stable/hackmd"
            version: "1.1.0"
        }
        db: {
            location: "eastus"
            database: "hackmd"
            admin: {
                username: "myadminuser"
                password: "myAdminPass123!"
            }
        }
        session: {
            secret: "abcde12345"
        }
    }
}

-- MyCloudApp is a custom class which installs HackMD with an Azure SQL DB
class MyCloudApp extends App
    new: (...) =>
        super(...)
        super\add_mixin("azure")
        super\add_mixin("helm")
        super\add_credentials("kubeconfig", "/root/.kube/config")
        @init_hackmd()

    init_hackmd: =>
        -- Azure PostgreSQL database
        azure_db = AzurePostgreSQLDatabase(@bundle.name.."-hackmd", settings.hackmd.db.location,
            settings.hackmd.db.database, settings.hackmd.db.admin.username, settings.hackmd.db.admin.password)
        azure_db_host = azure_db\get_host()

        -- HackMD Helm chart pointing to new database
        helm_release = HelmRelease(@bundle.name.."-hackmd", settings.hackmd.chart.ref, settings.hackmd.chart.version)
        helm_release\set_values({
            "replicaCount":                settings.hackmd.replicas
            "sessionSecret":               settings.hackmd.session.secret
            "persistence.enabled":         false
            "postgresql.install":          false
            "postgresql.postgresUser":     settings.hackmd.db.admin.username.."@"..azure_db_host
            "postgresql.postgresPassword": settings.hackmd.db.admin.password
            "postgresql.postgresDatabase": settings.hackmd.db.database
            "postgresql.postgresHost":     azure_db_host
            --"postgresql.postgresHost": {
            --    source: "bundle.azure.outputs.POSTGRESQL_HOST"
            --}
        })

        -- Add install steps
        super\add_install_step(azure_db\install())
        super\add_install_step(helm_release\install())

        -- Add upgrade steps
        super\add_upgrade_step(helm_release\upgrade())

        -- Add uninstall steps
        super\add_uninstall_step(helm_release\uninstall())

return {
    MyCloudApp: MyCloudApp
}
