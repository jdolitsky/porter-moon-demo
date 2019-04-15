-- mycloudapp.moon

import App from require("lib/base")
import AmazonEKSCluster from require("lib/terraform")

-- DevCluster is a custom class which creates an Amazon EKS cluster
-- using Terraform mixin and installs things into it using Helm mixin
class DevCluster extends App
    new: (...) =>
        super(...)
        super\add_mixin("terraform")
        super\add_parameter("file_contents", "string")
        @init_cluster()

    init_cluster: =>
        -- Amazon EKS Cluster (Kubernetes)
        eks_cluster = AmazonEKSCluster()

        -- Add install steps
        super\add_install_step(eks_cluster\install())

        -- Add upgrade steps
        super\add_upgrade_step(eks_cluster\upgrade())

        -- Add status steps
        super\add_status_step(eks_cluster\status())

        -- Add uninstall steps
        super\add_uninstall_step(eks_cluster\uninstall())

return {
    DevCluster: DevCluster
}
