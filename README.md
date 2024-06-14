Sample
======

This is sample repository of CaaS deployment pipeline.

## Firstly

Please follow [Create deploy job](docs/createDeployJob.md).

## Directory structure

```
.
├── Dockerfile
├── Jenkinsfile
├── Jenkinsfile.app-repo
├── README.md
├── base
│   ├── deployment.yaml
│   ├── kustomization.yaml
│   └── service.yaml
└── overlays
    ├── beta
    │   └── kustomization.yaml
    ├── local
    │   ├── kustomization.yaml
    │   └── sa.yaml
    └── release
        ├── kustomization.yaml
        └── resources.yaml

```

### Dockerfile

Dockerfile is a container image definition file for [Docker](https://www.docker.com/). More detail please see https://docs.docker.com/engine/reference/builder/

As a sample we put Dockerfile on same repository as Kubernetes manifest file repository. You can put Dockerfile on same repository as Application source repository also.

If you want to use Dockerfile which exists in external git repository, please reference [External app repo](docs/externalAppRepo.md).

### Jenkinsfile

Jenkinsfile is a pipeline definition file for [Jenkins](https://jenkins.io/). More detail please see https://jenkins.io/doc/book/pipeline/jenkinsfile/

### Jenkinsfile.app-repo

If you want to manage Kubernetes manifest files and APP source code separately, you can reference this Jenkinsfile.

This sample show you how to checkout additional git repository and build Docker image with the repository.

### Kustomize

*base* and *overlays* directories are recommended structure for [Kustomize](https://github.com/kubernetes-sigs/kustomize). With Kustomize you don't have to copy whole manifest files per environment.

#### base

Common definition files are put on this directory.

#### overlays/xxx

Environment specific settings are put on this directory. Only additional or different settings you need to define.

If you want to add more environment, please reference [Add new environment](docs/addNewEnv.md).

##### overlays/local

You can test this repository on your local env with [minikube](https://minikube.sigs.k8s.io/docs/) or [kind](https://kind.sigs.k8s.io/).

You only have to install kubectl, kustomize and some local Kubernetes tool then run following command please.

```
$ kustomize build overlays/local | kubectl apply -f -
```

Nginx Deployment and Service resource will be created as `sample-local`.

Following command setup reverse proxy from local `50000` port to sample-local Service `8080` port.

```
$ kubectl port-forward service/sample-local 50000:8080
```

Let's access http://localhost:50000 you can see Nginx top page.

