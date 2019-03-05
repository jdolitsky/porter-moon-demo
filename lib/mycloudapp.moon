-- mycloudapp.moon

import App from require("lib/base")
import HelmRelease from require("lib/helm")

-- component-specific settings
settings = {
    hackmd: {
        chart: {
            ref:     "stable/hackmd"
            version: "1.0.1"
        }
    }
}

-- MyCloudApp is a custom class which installs HackMD with an Azure SQL DB
class MyCloudApp extends App
    new: (...) =>
        super(...)
        super\add_mixin("helm")
        super\add_credentials("kubeconfig", "/root/.kube/config")
        @init_hackmd()

    init_hackmd: =>
        helm_release = HelmRelease(@bundle.name.."-hackmd", settings.hackmd.chart.ref, settings.hackmd.chart.version)
        super\add_install_step(helm_release\install())
        super\add_upgrade_step(helm_release\upgrade())
        super\add_uninstall_step(helm_release\uninstall())

return {
    MyCloudApp: MyCloudApp
}
