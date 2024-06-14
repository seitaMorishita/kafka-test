Add new environment
===================

Before adding new environment install *kustomize* CLI please. see https://kubectl.docs.kubernetes.io/installation/kustomize/

## Add new env dir

```sh
$ export NEW_ENVIRONMENT=pre

# Create new directory for the environment
# This time adding pre environment
$ mkdir overlays/${NEW_ENVIRONMENT}

# Go to directory of the environment
$ cd overlays/${NEW_ENVIRONMENT}

# Create configuration file for kustomize
$ touch kustomization.yaml

# Link with base
$ kustomize edit add base ../../base

# To separate from other env adding suffix and env spesific label
$ kustomize edit set namesuffix -- "-${NEW_ENVIRONMENT}"
$ kustomize edit add label "env:${NEW_ENVIRONMENT}"

# Operation check. Expect: resource definition is output without any error
$ kustomize build

# If you need, add more environment specific settings please
```

## Add new env to FLOW

If you add new env `pre` between `beta` and `release`, you can force promoting the image in the `pre` environment to deploy to the `release` environment.
Because Docker image for the `release` env is promoted from `pre`.

### AsIs

```sh
def FLOW = [
	[env: "beta",    clusterId: "jpe2-caas1-prod1", namespace: "${env.JOB_NAME.split('/')[3]}", image: "build"],
	[env: "release", clusterId: "jpe2-caas1-prod1", namespace: "${env.JOB_NAME.split('/')[3]}", image: "promote"]
]
```

### ToBe

```sh
def FLOW = [
	[env: "beta",    clusterId: "jpe2-caas1-prod1", namespace: "${env.JOB_NAME.split('/')[3]}", image: "build"],
	[env: "pre",     clusterId: "jpe2-caas1-prod1", namespace: "${env.JOB_NAME.split('/')[3]}", image: "promote"],
	[env: "release", clusterId: "jpe2-caas1-prod1", namespace: "${env.JOB_NAME.split('/')[3]}", image: "promote"]
]
```
