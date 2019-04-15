-- terraform.moon

-- AmazonEKSCluster is a class for working with Amazon EKS (managed Kubernetes service)
class AmazonEKSCluster
    _format: (o) => {terraform: o}

    new: () =>

    install: =>
        @_format({
            description: "Install Terraform assets"
            autoApprove: true
            vars: {
                file_contents: {
                    source: "bundle.parameters.file_contents"
                }
            }
        })

    upgrade: =>
        @_format({
            description: "Upgrade Terraform assets"
            autoApprove: true
            vars: {
                file_contents: {
                    source: "bundle.parameters.file_contents"
                }
            }
        })

    status: =>
        @_format({
            description: "Get Terraform status"
        })

    uninstall: =>
        @_format({
            description: "Uninstall Terraform assets"
            autoApprove: true
        })

return {
    AmazonEKSCluster: AmazonEKSCluster
}
