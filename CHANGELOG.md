# Changelog

## [9.0.0](https://github.com/camptocamp/devops-stack-module-traefik/compare/v8.2.0...v9.0.0) (2024-10-09)


### ⚠ BREAKING CHANGES

* point the Argo CD provider to the new repository ([#88](https://github.com/camptocamp/devops-stack-module-traefik/issues/88))

### Features

* point the Argo CD provider to the new repository ([#88](https://github.com/camptocamp/devops-stack-module-traefik/issues/88)) ([8fdd7ec](https://github.com/camptocamp/devops-stack-module-traefik/commit/8fdd7ec81a4f432050542fa3fdc568f8c7fea3cb))

### Migrate provider source `oboukili` -> `argoproj-labs`

We've tested the procedure found [here](https://github.com/argoproj-labs/terraform-provider-argocd?tab=readme-ov-file#migrate-provider-source-oboukili---argoproj-labs) and we think the order of the steps is not exactly right. This is the procedure we recommend (**note that this should be run manually on your machine and not on a CI/CD workflow**):

1. First, make sure you are already using version 6.2.0 of the `oboukili/argocd` provider.

1. Then, check which modules you have that are using the `oboukili/argocd` provider.

```shell
$ terraform providers

Providers required by configuration:
.
├── provider[registry.terraform.io/hashicorp/helm] 2.15.0
├── (...)
└── provider[registry.terraform.io/oboukili/argocd] 6.2.0

Providers required by state:

    (...)

    provider[registry.terraform.io/oboukili/argocd]

    provider[registry.terraform.io/hashicorp/helm]
```

3. Afterwards, proceed to point **ALL*  the DevOps Stack modules to the versions that have changed the source on their respective requirements. In case you have other personal modules that also declare `oboukili/argocd` as a requirement, you will also need to update them.

4. Also update the required providers on your root module. If you've followed our examples, you should find that configuration on the `terraform.tf` file in the root folder.

5. Execute the migration  via `terraform state replace-provider`:

```bash
$ terraform state replace-provider registry.terraform.io/oboukili/argocd registry.terraform.io/argoproj-labs/argocd
Terraform will perform the following actions:

  ~ Updating provider:
    - registry.terraform.io/oboukili/argocd
    + registry.terraform.io/argoproj-labs/argocd

Changing 13 resources:

  module.argocd_bootstrap.argocd_project.devops_stack_applications
  module.secrets.module.secrets.argocd_application.this
  module.metrics-server.argocd_application.this
  module.efs.argocd_application.this
  module.loki-stack.module.loki-stack.argocd_application.this
  module.thanos.module.thanos.argocd_application.this
  module.cert-manager.module.cert-manager.argocd_application.this
  module.kube-prometheus-stack.module.kube-prometheus-stack.argocd_application.this
  module.argocd.argocd_application.this
  module.traefik.module.traefik.module.traefik.argocd_application.this
  module.ebs.argocd_application.this
  module.helloworld_apps.argocd_application.this
  module.helloworld_apps.argocd_project.this

Do you want to make these changes?
Only 'yes' will be accepted to continue.

Enter a value: yes

Successfully replaced provider for 13 resources.
```

6. Perform a `terraform init -upgrade` to upgrade your local `.terraform` folder.

7. Run a `terraform plan` or `terraform apply` and you should see that everything is OK and that no changes are necessary. 

## [8.2.0](https://github.com/camptocamp/devops-stack-module-traefik/compare/v8.1.0...v8.2.0) (2024-08-28)


### Features

* add a label to traefik pods ([#85](https://github.com/camptocamp/devops-stack-module-traefik/issues/85)) ([31150dc](https://github.com/camptocamp/devops-stack-module-traefik/commit/31150dc51ca638babe734cf2dbda099f53f9283c))

## [8.1.0](https://github.com/camptocamp/devops-stack-module-traefik/compare/v8.0.0...v8.1.0) (2024-08-20)


### Features

* **chart:** minor update of dependencies on traefik chart ([#83](https://github.com/camptocamp/devops-stack-module-traefik/issues/83)) ([58b3f1c](https://github.com/camptocamp/devops-stack-module-traefik/commit/58b3f1ceed146c75f839adb6c4cd9ac0bb671449))

## [8.0.0](https://github.com/camptocamp/devops-stack-module-traefik/compare/v7.0.0...v8.0.0) (2024-08-15)


### ⚠ BREAKING CHANGES

* **chart:** major update of dependencies on traefik chart
  * The [v30](https://github.com/traefik/traefik-helm-chart/compare/v29.0.1...v30.0.0) of the chart includes a breaking change because the values of the Gateway API implementation have changed. This change does not affect us directly on the DevOps Stack, and since this is a very new feature I do not see it affecting any of our deployments.

### Features

* **chart:** major update of dependencies on traefik chart ([1ba9afa](https://github.com/camptocamp/devops-stack-module-traefik/commit/1ba9afabf6521c21395de447fd32485cb66d041f))

## [7.0.0](https://github.com/camptocamp/devops-stack-module-traefik/compare/v6.3.0...v7.0.0) (2024-07-10)


### ⚠ BREAKING CHANGES

* **chart:** major update of dependencies on traefik chart ([#77](https://github.com/camptocamp/devops-stack-module-traefik/issues/77)):

  * [v26.1.0 -> v27.0.0](https://github.com/traefik/traefik-helm-chart/releases/tag/v27.0.0):
    * if you were overriding port exposure behavior using the `expose` or `exposeInternal` flags, you should replace them with a service name to boolean mapping ([check the official changelog](https://github.com/traefik/traefik-helm-chart/releases/tag/v27.0.0) for an example).
    * if you were previously using the `service.internal` value, you should migrate the values to the `service.additionalServices.internal` value instead; this should yield the same results, but make sure to carefully check for any changes!
    * resources that use the `traefik.containo.us` are definitely no longer supported; the other modules of the DevOps Stack have already been migrated, but make sure you make the changes on your side.

  * [v27.0.2 -> v28.0.0](https://github.com/traefik/traefik-helm-chart/releases/tag/v28.0.0):
    * multiple CRDs have been updated but the users of the DevOps Stack do not need to update them manually since Argo CD takes care of it;
    * the upstream team added the first experimental support for Traefik v3; a migration guide for your resources is available [here](https://doc.traefik.io/traefik/v3.0/migration/v2-to-v3/);
    * this upgrade also introduces support to OpenTelemetry; although this is not a breaking change, it is noteworthy;

  * [v28.3.0 -> v29.0.0](https://github.com/traefik/traefik-helm-chart/compare/v28.3.0...v29.0.0):
    * there is change in the values that affects the way we activate the ServiceMonitor for Prometheus; we can now use an attribute `enabled` to activate it; see [here](https://github.com/traefik/traefik-helm-chart/pull/1114);
    * Kubernetes Gateway support is no longer experimental;
    * the IngressRoute for the Traefik Dashboard is now disabled by default.

### Features

* **chart:** major update of dependencies on traefik chart ([#77](https://github.com/camptocamp/devops-stack-module-traefik/issues/77)) ([cb2daac](https://github.com/camptocamp/devops-stack-module-traefik/commit/cb2daac0d5e64f4851686c2ae25176033912d9fa))

## [6.3.0](https://github.com/camptocamp/devops-stack-module-traefik/compare/v6.2.0...v6.3.0) (2024-04-17)


### Features

* add variable to set resources with default values ([#76](https://github.com/camptocamp/devops-stack-module-traefik/issues/76)) ([ed77f88](https://github.com/camptocamp/devops-stack-module-traefik/commit/ed77f885196f7c0b10e77190f7643607cef88aa0))

## [6.2.0](https://github.com/camptocamp/devops-stack-module-traefik/compare/v6.1.1...v6.2.0) (2024-03-01)


### Features

* make the dashboard deployment dynamic ([#74](https://github.com/camptocamp/devops-stack-module-traefik/issues/74)) ([8b99d6e](https://github.com/camptocamp/devops-stack-module-traefik/commit/8b99d6eac6b0f28746b9fd8193bee5061d6e67f1))

## [6.1.1](https://github.com/camptocamp/devops-stack-module-traefik/compare/v6.1.0...v6.1.1) (2024-02-23)


### Bug Fixes

* remove leftover unused variable ([#72](https://github.com/camptocamp/devops-stack-module-traefik/issues/72)) ([c4c882d](https://github.com/camptocamp/devops-stack-module-traefik/commit/c4c882dfe2be01194a7faf9faf71e4be4059348f))

## [6.1.0](https://github.com/camptocamp/devops-stack-module-traefik/compare/v6.0.0...v6.1.0) (2024-02-23)


### Features

* **chart:** minor update of dependencies on traefik chart ([#69](https://github.com/camptocamp/devops-stack-module-traefik/issues/69)) ([1d4d130](https://github.com/camptocamp/devops-stack-module-traefik/commit/1d4d130a0ebae2c08373b3f16f26f36667f2985c))

## [6.0.0](https://github.com/camptocamp/devops-stack-module-traefik/compare/v5.0.0...v6.0.0) (2024-02-23)


### :warning: BREAKING CHANGES

* move global variables to the variant that requires them
  
  After the removal of the redirection middleware, we noticed that the variables `cluster_name` and `base_domain` were not used except in the AKS variant, as such, we relocated them specifically to that variant.

  As such, this is a breaking change for all the variants, with the exception of the AKS variant.

### :warning: WARNING

* remove the middleware to allow configuration of the subdomain

  The addition of the variable `subdomain` on the other DevOps Stack modules posed some issues with the redirection middleware added by this module when the variable was set as an empty string. Consequently, we pondered on the utility of said middleware and we decided it is best to remove it.

  This is not a breaking change *per se*, but you need to make sure of 2 things:
    - you callback URLs on your OIDC configuration now need to include both the domain with and without the cluster name, otherwise you will have authentication errors.
    - if you any of your workload´s ingresses relied on the this middleware for redirection, make sure to adapt it to respond to both the domain with and without the cluster name. 


### Bug Fixes

* make subdomain variable non-nullable ([014bb29](https://github.com/camptocamp/devops-stack-module-traefik/commit/014bb2914f4ac81d67245c40900f5c83b30042b9))
* move global variables to the variant that requires them ([657a829](https://github.com/camptocamp/devops-stack-module-traefik/commit/657a82912776103302c1887b61cdd97fa62cfcc0))
* remove the middleware to allow configuration of the subdomain ([37d7f4d](https://github.com/camptocamp/devops-stack-module-traefik/commit/37d7f4d13f3b9eae94eefbce15b88c4801f9cf7c))

## [5.0.0](https://github.com/camptocamp/devops-stack-module-traefik/compare/v4.1.0...v5.0.0) (2024-01-15)


### ⚠ BREAKING CHANGES

* **aks:** remove DNS resources from this module
* remove the ArgoCD namespace variable
* remove the namespace variable
* hardcode the release name to remove the destination cluster
* **chart:** major update of dependencies on traefik chart ([#64](https://github.com/camptocamp/devops-stack-module-traefik/issues/64)): 
  The 2 breaking changes noted on the official release notes are applicable to only the users that overload the `deployment.podAnnotations` or the `experimental.plugins keys`. The behavior of these keys has changed, as described in the PRs https://github.com/traefik/traefik-helm-chart/pull/972 and https://github.com/traefik/traefik-helm-chart/pull/961, respectively.

### Features

* **aks:** remove DNS resources from this module ([19eb83a](https://github.com/camptocamp/devops-stack-module-traefik/commit/19eb83ad3167409b789fe52ac4adb2c536d35e0a))
* **chart:** major update of dependencies on traefik chart ([#64](https://github.com/camptocamp/devops-stack-module-traefik/issues/64)) ([d7e1327](https://github.com/camptocamp/devops-stack-module-traefik/commit/d7e1327d2cc65fa6ed28c75038aae2d8baee7390))


### Bug Fixes

* hardcode the release name to remove the destination cluster ([18a4d45](https://github.com/camptocamp/devops-stack-module-traefik/commit/18a4d45f9ca22ebeea1df9c7ae053095e871d078))
* remove the ArgoCD namespace variable ([524d6c2](https://github.com/camptocamp/devops-stack-module-traefik/commit/524d6c2a139ebec869b24108a407118c137b01d2))
* remove the namespace variable ([3e7b33f](https://github.com/camptocamp/devops-stack-module-traefik/commit/3e7b33fefc2cc928557a29e3b144a1e40efcdbf3))

## [4.1.0](https://github.com/camptocamp/devops-stack-module-traefik/compare/v4.0.0...v4.1.0) (2023-11-10)


### Features

* add HTTP to HTTPS redirection with associated variable ([574cd2b](https://github.com/camptocamp/devops-stack-module-traefik/commit/574cd2bfe68a9e155df02522bd4a43de81589a40))


### Bug Fixes

* add propagation of dependency ids on the Scaleway variant ([c52a812](https://github.com/camptocamp/devops-stack-module-traefik/commit/c52a812f2896affe292f2217558c625926006510))
* change Traefik CRD group to the one introduced in v23 ([304f010](https://github.com/camptocamp/devops-stack-module-traefik/commit/304f0105b616f023de5e98a6e1b5b7332adb1ff9))

## [4.0.0](https://github.com/camptocamp/devops-stack-module-traefik/compare/v3.1.0...v4.0.0) (2023-11-02)


### ⚠ BREAKING CHANGES

* **chart:** major update of dependencies on traefik chart ([#60](https://github.com/camptocamp/devops-stack-module-traefik/issues/60)): if you are overloading the following values using the `helm_values` variable, please beware of the following breaking changes:

  - On `redirectTo`, `ports.web.redirectTo=websecure` should become `ports.web.redirectTo.port=websecure`. More details in [this PR](https://github.com/traefik/traefik-helm-chart/pull/934).
  - On `gateway`, all values are now flattened to `experimental.kubernetesGateway`. More details in [this PR](https://github.com/traefik/traefik-helm-chart/pull/927).

### Features

* **chart:** major update of dependencies on traefik chart ([#60](https://github.com/camptocamp/devops-stack-module-traefik/issues/60)) ([915831e](https://github.com/camptocamp/devops-stack-module-traefik/commit/915831eadd082e34995e9742536b6535de0f9ab4))

## [3.1.0](https://github.com/camptocamp/devops-stack-module-traefik/compare/v3.0.0...v3.1.0) (2023-10-19)


### Features

* add standard variables and variable to add labels to Argo CD app ([c537d85](https://github.com/camptocamp/devops-stack-module-traefik/commit/c537d85fd0d7a68faebf495793ed0561048d6448))
* add variables to set AppProject and destination cluster ([882ebb7](https://github.com/camptocamp/devops-stack-module-traefik/commit/882ebb7ba8c23fb139e2dfb9eed31793511fade0))

## [3.0.0](https://github.com/camptocamp/devops-stack-module-traefik/compare/v2.0.1...v3.0.0) (2023-08-18)


### ⚠ BREAKING CHANGES

* **chart:** major update of dependencies on traefik chart ([#56](https://github.com/camptocamp/devops-stack-module-traefik/issues/56)):

  - [v20 -> v21](https://github.com/traefik/traefik-helm-chart/releases/tag/v21.0.0) - the changelog is not clear on what the breaking changes were...
  - [v21 -> v22](https://github.com/traefik/traefik-helm-chart/releases/tag/v22.0.0) - `image.registry` was introduced in the `values.yaml` and if someone is overriding `image.repository`on their code they may also need to set `image.registry` (otherwise does not affect the internal code of the module);
  - [v22 -> v23](https://github.com/traefik/traefik-helm-chart/releases/tag/v23.0.0) - the `API Group` of the CRDs was updated from `*.traefik.containo.us` to `*.traefik.io`; Argo CD is able to take care of this update automatically; **note that for the time being, the chart deploys both versions of the API Group but this could change in the future, sou you need to update your workloads accordingly**;
  - [v23 -> v24](https://github.com/traefik/traefik-helm-chart/releases/tag/v24.0.0) - `healthchecksPort` and `healthchecksScheme` has moved from `ports.traefik` to `deployment`;

### Features

* **chart:** major update of dependencies on traefik chart ([#56](https://github.com/camptocamp/devops-stack-module-traefik/issues/56)) ([1181b22](https://github.com/camptocamp/devops-stack-module-traefik/commit/1181b22c7ded719ddc2ae82137e1a283b054d0f6))

## [2.0.1](https://github.com/camptocamp/devops-stack-module-traefik/compare/v2.0.0...v2.0.1) (2023-08-09)


### Bug Fixes

* readd support to deactivate auto-sync which was broken by [#52](https://github.com/camptocamp/devops-stack-module-traefik/issues/52) ([c1ac289](https://github.com/camptocamp/devops-stack-module-traefik/commit/c1ac28974a912c7497fe2494ead06c6bfd0bbae0))

## [2.0.0](https://github.com/camptocamp/devops-stack-module-traefik/compare/v1.2.3...v2.0.0) (2023-07-11)


### ⚠ BREAKING CHANGES

* add support to oboukili/argocd v5 ([#52](https://github.com/camptocamp/devops-stack-module-traefik/issues/52))

### Features

* add support to oboukili/argocd v5 ([#52](https://github.com/camptocamp/devops-stack-module-traefik/issues/52)) ([dc9191f](https://github.com/camptocamp/devops-stack-module-traefik/commit/dc9191f4b0af5832255de86291d56ab0c92c35ed))

## [1.2.3](https://github.com/camptocamp/devops-stack-module-traefik/compare/v1.2.2...v1.2.3) (2023-06-12)


### Bug Fixes

* **KinD:** avoid deferring data source reading when Helm values change ([#50](https://github.com/camptocamp/devops-stack-module-traefik/issues/50)) ([5ae76ca](https://github.com/camptocamp/devops-stack-module-traefik/commit/5ae76ca2b9175a30ca27e1822f5f0b1fbe1955f5))

## [1.2.2](https://github.com/camptocamp/devops-stack-module-traefik/compare/v1.2.1...v1.2.2) (2023-05-30)


### Bug Fixes

* add missing providers ([#48](https://github.com/camptocamp/devops-stack-module-traefik/issues/48)) ([9ecaaeb](https://github.com/camptocamp/devops-stack-module-traefik/commit/9ecaaeb0229d95a07d6f39a79625a8938680d3ec))

## [1.2.1](https://github.com/camptocamp/devops-stack-module-traefik/compare/v1.2.0...v1.2.1) (2023-05-26)


### Bug Fixes

* enable_service_monitor variable propagation from flavors to base module ([#46](https://github.com/camptocamp/devops-stack-module-traefik/issues/46)) ([5449546](https://github.com/camptocamp/devops-stack-module-traefik/commit/54495467b9b3685a5eaba3aab46ae5414482fc8b))

## [1.2.0](https://github.com/camptocamp/devops-stack-module-traefik/compare/v1.1.0...v1.2.0) (2023-05-22)


### Features

* enable monitoring by default and add Grafana dashboard ([#41](https://github.com/camptocamp/devops-stack-module-traefik/issues/41)) ([b89897d](https://github.com/camptocamp/devops-stack-module-traefik/commit/b89897d501efd7e763ec15e776d3718a77d2208e))

## [1.1.0](https://github.com/camptocamp/devops-stack-module-traefik/compare/v1.0.0...v1.1.0) (2023-05-17)


### Features

* add variable for replicas ([#40](https://github.com/camptocamp/devops-stack-module-traefik/issues/40)) ([fdc0613](https://github.com/camptocamp/devops-stack-module-traefik/commit/fdc0613735b0bfbc1e3cf5b30cfa8f4c0684fefe))
* **sks:** add configuration to make Traefik work with new SKS module ([#44](https://github.com/camptocamp/devops-stack-module-traefik/issues/44)) ([50f4f8f](https://github.com/camptocamp/devops-stack-module-traefik/commit/50f4f8fa9b52d7fa304367aeba66123d3540b7f9))

## [1.0.0](https://github.com/camptocamp/devops-stack-module-traefik/compare/v1.0.0-alpha.9...v1.0.0) (2023-03-24)


### Documentation

* add docs structure and PR template ([#36](https://github.com/camptocamp/devops-stack-module-traefik/issues/36)) ([37b30ab](https://github.com/camptocamp/devops-stack-module-traefik/commit/37b30ab877ca4a80d6ad86d17a77ceefc937d8af))

## [1.0.0-alpha.9](https://github.com/camptocamp/devops-stack-module-traefik/compare/v1.0.0-alpha.8...v1.0.0-alpha.9) (2023-02-22)


### Features

* add KinD module ([#31](https://github.com/camptocamp/devops-stack-module-traefik/issues/31)) ([7cbafa7](https://github.com/camptocamp/devops-stack-module-traefik/commit/7cbafa75ba3f97f5387b45e03817c9055c482a45))

## [1.0.0-alpha.8](https://github.com/camptocamp/devops-stack-module-traefik/compare/v1.0.0-alpha.7...v1.0.0-alpha.8) (2023-01-31)


### Features

* **helm:** bump version to 20 ([#32](https://github.com/camptocamp/devops-stack-module-traefik/issues/32)) ([0a4c598](https://github.com/camptocamp/devops-stack-module-traefik/commit/0a4c598faf1e74b3d7496bf9351997a459cc2c25))

## [1.0.0-alpha.7](https://github.com/camptocamp/devops-stack-module-traefik/compare/v1.0.0-alpha.6...v1.0.0-alpha.7) (2023-01-30)


### Features

* **wait:** add dependency to var app_autosync ([#30](https://github.com/camptocamp/devops-stack-module-traefik/issues/30)) ([430597e](https://github.com/camptocamp/devops-stack-module-traefik/commit/430597e4e42d8a4babb035351faf249f9ec490cb))

## [1.0.0-alpha.6](https://github.com/camptocamp/devops-stack-module-traefik/compare/v1.0.0-alpha.5...v1.0.0-alpha.6) (2022-12-14)


### Bug Fixes

* **main:** enrich autosync var and default to true ([#28](https://github.com/camptocamp/devops-stack-module-traefik/issues/28)) ([5b5b169](https://github.com/camptocamp/devops-stack-module-traefik/commit/5b5b1690c17d8a8bda7179ddb9de93c21e6fe10b))

## [1.0.0-alpha.5](https://github.com/camptocamp/devops-stack-module-traefik/compare/v1.0.0-alpha.4...v1.0.0-alpha.5) (2022-12-09)


### Features

* **main:** introduce a variable to set autosync ([#25](https://github.com/camptocamp/devops-stack-module-traefik/issues/25)) ([b418a72](https://github.com/camptocamp/devops-stack-module-traefik/commit/b418a72e3125843eb0368fd300857a3ba72949f7))

## [1.0.0-alpha.4](https://github.com/camptocamp/devops-stack-module-traefik/compare/v1.0.0-alpha.3...v1.0.0-alpha.4) (2022-12-06)


### Bug Fixes

* **chart:** fix last PR ([#22](https://github.com/camptocamp/devops-stack-module-traefik/issues/22)) ([a93184f](https://github.com/camptocamp/devops-stack-module-traefik/commit/a93184fbc5d0bf026a6210805c1fd887db372528))

## [1.0.0-alpha.3](https://github.com/camptocamp/devops-stack-module-traefik/compare/v1.0.0-alpha.2...v1.0.0-alpha.3) (2022-12-05)


### Features

* **chart:** bump Chart version to support proxy-protocol ([#16](https://github.com/camptocamp/devops-stack-module-traefik/issues/16)) ([0530512](https://github.com/camptocamp/devops-stack-module-traefik/commit/053051267ad0f52335a77b34a3134d6e9306c41c))

## [1.0.0-alpha.2](https://github.com/camptocamp/devops-stack-module-traefik/compare/v1.0.0-alpha.1...v1.0.0-alpha.2) (2022-12-01)


### Bug Fixes

* **aks:** homogenize rg naming convention between modules ([bba2613](https://github.com/camptocamp/devops-stack-module-traefik/commit/bba261369503559727b492fdd0bbaf758f5111f2))
* **aks:** typo ([e6778be](https://github.com/camptocamp/devops-stack-module-traefik/commit/e6778be72ba8ee19837ce707b396cfc0a4fda726))
* separate DNS zone and cluster resource groups ([95c9633](https://github.com/camptocamp/devops-stack-module-traefik/commit/95c96336736c1d5de579db4c0dd8e6d4b828b466))

## 1.0.0-alpha.1 (2022-11-18)


### ⚠ BREAKING CHANGES

* move Terraform module at repository root
* **sks:** remove load-balancer (back into cluster module)
* use var.cluster_info

### Features

* add aks profile ([e21da39](https://github.com/camptocamp/devops-stack-module-traefik/commit/e21da39c61ffc079a6e38cd31b6c84c50664cb01))
* add eks profile ([9910a51](https://github.com/camptocamp/devops-stack-module-traefik/commit/9910a51ff5990350bcb9f587d8c2dbce9e2445d7))
* add SKS and NodePort support ([7e1f79f](https://github.com/camptocamp/devops-stack-module-traefik/commit/7e1f79f832de0209b335a0dd132c21e7b86af6fa))
* add support of scaleway ([b4ccc2e](https://github.com/camptocamp/devops-stack-module-traefik/commit/b4ccc2e40463d3b78049dd522c758aa3513da7bc))
* allow value overrides ([fb09562](https://github.com/camptocamp/devops-stack-module-traefik/commit/fb09562124232073a0500d7f4f438eaf95613821))
* make variables optional ([633ea88](https://github.com/camptocamp/devops-stack-module-traefik/commit/633ea887c5d0459842270c76440c5554569db114))
* merge with cloudposse/utils ([e878600](https://github.com/camptocamp/devops-stack-module-traefik/commit/e878600c4460b0e710c69f9eaaf8bba58dff9805))
* move profiles to submodules ([13337a2](https://github.com/camptocamp/devops-stack-module-traefik/commit/13337a251dd132cd0b4004b174f9cd49b9470ec7))
* pass helm values in HCL ([ad36585](https://github.com/camptocamp/devops-stack-module-traefik/commit/ad36585a3148ea4942f3e4ca899fdde95858566c))
* pass profiles as a list ([ee7a018](https://github.com/camptocamp/devops-stack-module-traefik/commit/ee7a0189d394726f0a518abc14959182898c5926))
* **sks:** add base_domain default ([10e849a](https://github.com/camptocamp/devops-stack-module-traefik/commit/10e849a0f47e8ef217567059026962f327cd9b0b))
* **sks:** add nlb_ip_address output ([7d28c88](https://github.com/camptocamp/devops-stack-module-traefik/commit/7d28c888fc09ff96f2371b6146599b806d17791f))
* **sks:** create NLB ([426b494](https://github.com/camptocamp/devops-stack-module-traefik/commit/426b4948542ad7785c4fa43aa3561900e293eadc))
* **sks:** remove load-balancer (back into cluster module) ([4f1a28b](https://github.com/camptocamp/devops-stack-module-traefik/commit/4f1a28bcd06571b93a5a2d1ec256bc8c4b15ad60))
* use argocd_namespace as variable ([2eef211](https://github.com/camptocamp/devops-stack-module-traefik/commit/2eef21190746c4d5584002c9c4ee0fbc82b2cd43))


### Bug Fixes

* add extra-variables.tf ([637fcdb](https://github.com/camptocamp/devops-stack-module-traefik/commit/637fcdbc16e3ae367852b65601ba76699913f9ad))
* **aks:** add resource_group_name variable ([7582dd3](https://github.com/camptocamp/devops-stack-module-traefik/commit/7582dd31b4ec714eff2349e5ce672dae70ad4491))
* **aks:** compute dns ([5399f91](https://github.com/camptocamp/devops-stack-module-traefik/commit/5399f9132ccaf78db4e95210edc403cc24dfdfb1))
* **aks:** sym link to version so providers get declared ([a6526f5](https://github.com/camptocamp/devops-stack-module-traefik/commit/a6526f5168ee92856632c2f9e1e765111b0872b6))
* bump to chart version 15 ([9c2b44d](https://github.com/camptocamp/devops-stack-module-traefik/commit/9c2b44dcaaccb733aec70b2aa404cb82791dd1fa))
* do not delay Helm values evaluation ([0ee90ec](https://github.com/camptocamp/devops-stack-module-traefik/commit/0ee90ec9a1aea19f96ab473d79a496be14376b17))
* Fix infinite redirection ([9f9b60b](https://github.com/camptocamp/devops-stack-module-traefik/commit/9f9b60b0b7f56d6ba32777cf4f36aa978145f7e6))
* merge extra_yaml in app values ([0819118](https://github.com/camptocamp/devops-stack-module-traefik/commit/08191188c358437a9e44a0792a31484a5f610c22))
* README ([c8ab992](https://github.com/camptocamp/devops-stack-module-traefik/commit/c8ab9926f322833a93c23e9edd84d66b199584a2))
* remove deprecated variable azure_dns_label_name ([83acc01](https://github.com/camptocamp/devops-stack-module-traefik/commit/83acc018aaa8be9f9b8942f7a06d898873567b04))
* **scaleway:** add output to scaleway ([8ca13d2](https://github.com/camptocamp/devops-stack-module-traefik/commit/8ca13d2500f874c8c781622008a1dd15173e5a90))
* **sks:** add versions.tf ([ef39596](https://github.com/camptocamp/devops-stack-module-traefik/commit/ef39596c07522dbc9d24353791477903e309b68d))
* use ClusterIP for eks ([c1b83a6](https://github.com/camptocamp/devops-stack-module-traefik/commit/c1b83a6061ac445a31efe9c8297a85b187f10fc2))
* values.tmpl.yaml reference in sub-modules ([e4e1084](https://github.com/camptocamp/devops-stack-module-traefik/commit/e4e1084fc1aa39227ca46d89be023d4c66b35d69))
* wait for app removel before deleting the project ([c1c162c](https://github.com/camptocamp/devops-stack-module-traefik/commit/c1c162c5fd6e7c8f65c9b4095a13489640fdfe2e))
* work around argocd terraform provider default values ([88c5ccc](https://github.com/camptocamp/devops-stack-module-traefik/commit/88c5ccc48cf292e3df0f01e2234ef0b12d177e77))


### Code Refactoring

* move Terraform module at repository root ([a1798b9](https://github.com/camptocamp/devops-stack-module-traefik/commit/a1798b95b7c6d1663a3eca5a0af1a54b91625621))
* use var.cluster_info ([ee1cb82](https://github.com/camptocamp/devops-stack-module-traefik/commit/ee1cb82e0f17c8d04c3eb3a3f23e3d2938f0979c))


### Continuous Integration

* add central workflows including release-please ([#14](https://github.com/camptocamp/devops-stack-module-traefik/issues/14)) ([add1f51](https://github.com/camptocamp/devops-stack-module-traefik/commit/add1f51f59759069e57f88b93cb4b35def2e4949))
