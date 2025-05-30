/**
 * # AWS EKS GitHub Actions Runner Scale Set Controller Terraform module
 *
 * A Terraform module to deploy the [GitHub Actions Runner Scale Set Controller](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller) on Amazon EKS cluster.
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-github-actions-runner-scale-set-controller/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-github-actions-runner-scale-set-controller/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-github-actions-runner-scale-set-controller/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-github-actions-runner-scale-set-controller/actions/workflows/pre-commit.yaml)
 */
locals {
  addon = {
    name = "gha-rs-controller"

    helm_chart_name    = "gha-runner-scale-set-controller"
    helm_chart_version = "0.9.3"
    helm_repo_url      = "ghcr.io/actions/actions-runner-controller-charts"
  }

  addon_irsa = {
    (local.addon.name) = {}
  }

  addon_values = yamlencode({
    serviceAccount = {
      create = module.addon-irsa[local.addon.name].service_account_create
      name   = module.addon-irsa[local.addon.name].service_account_name
      annotations = module.addon-irsa[local.addon.name].irsa_role_enabled ? {
        "eks.amazonaws.com/role-arn" = module.addon-irsa[local.addon.name].iam_role_attributes.arn
      } : tomap({})
    }
  })

  addon_depends_on = []
}
