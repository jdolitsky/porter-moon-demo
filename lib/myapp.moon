import App from require("lib/app")
import HelmRelease from require("lib/helm")

-- Configuration related to HackMD Helm chart/release
hackmd_helm_release_name = "porter-hackmd-demo"
hackmd_helm_chart_ref = "stable/hackmd"
hackmd_helm_chart_version = "1.0.1"

-- Our custom MyApp class which builds upon the App base class
class MyApp extends App
    new: (...) =>
        super(...)
        super\add_mixin("helm")
        super\add_credentials("kubeconfig", "/root/.kube/config")
        hackmd = HelmRelease(hackmd_helm_release_name, hackmd_helm_chart_ref, hackmd_helm_chart_version)
        super\add_install_step(hackmd\install())
        super\add_upgrade_step(hackmd\upgrade())
        super\add_uninstall_step(hackmd\uninstall())

return {
    MyApp: MyApp
}
