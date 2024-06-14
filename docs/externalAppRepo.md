How to use Dockerfile which exists in external git repository
=============================================================

1. Register ssh key pair
1. Add checkout stage to Jenkinsfile
1. Change build context

Sample Jenkinsfile is [external-app-repo.Jenkinsfile](external-app-repo.Jenkinsfile).

## Register ssh key pair

Please reference [Create deploy job](createDeployJob.md) to generate and register ssh key pair for external git repository.

## Add checkout stage to Jenkinsfile

Add string parameter to the parameters section to be able to checkout any branch.

```
parameters {
  ...
  string(name: 'APP_REPO_BRANCH', description: 'branch or tag name for the Application repository', defaultValue: 'master')
}
```

Add repository information to the environment section.
Please modify values with your repository information.

```
environment {
  ...
  // Configurations for Application repository
  APP_REPO_URL     = 'ssh://git@git.rakuten-it.com:7999/caaspipeline/sample-app.git'
  APP_REPO_CREDS   = 'sample-app-git-access-key'
  APP_CHECKOUT_DIR = 'app'
}
```

Add new pipeline stage. With `checkoutRepo` method you can checkout your repository easily. The repository is checkouted under the `env.APP_CHECKOUT_DIR` to avoid mixing content with the manifest repository.

Instead of using manifest repository's git commit id, use external repository's commit id as a docker tag.

```
stage('Checkout APP repo') {
  steps {
    script {
      def repo = checkoutRepo(env.APP_REPO_URL, params.APP_REPO_BRANCH, env.APP_REPO_CREDS, env.APP_CHECKOUT_DIR)

      // BUILD_TIMESTAMP comes from https://plugins.jenkins.io/build-timestamp/ plugin
      // If you want to use different tag, change this logic please
      env.DOCKER_TAG = "${env.BUILD_TIMESTAMP}-${repo.GIT_COMMIT[0..6]}-${env.ENVIRONMENT}"
    }
  }
}
```

## Change build context

Wrap `cpd.withDockerRegistry` with `dir(env.APP_CHECKOUT_DIR)` to change docker build context. If the Dockerfile is in a location other than the root directory, specify path to Dockerfile with second argument of `docker.build` method. more detail https://jenkins.io/doc/book/pipeline/docker/#building-containers

```
stage('Build and Push image') {
  when {
    expression { flow.isBuildImage() }
  }
  steps {
    script {
      dir(env.APP_CHECKOUT_DIR) {
        cpd.withDockerRegistry(params.K8S_CLUSTER_ID, env.K8S_NAMESPACE) {
          // Build docker image with method of Jenkins docker plugin
          // https://jenkins.io/doc/book/pipeline/docker/
          def img = docker.build("${K8S_NAMESPACE}/${APP_NAME}:${env.DOCKER_TAG}")
          img.push()
          env.DOCKER_IMAGE = img.imageName()
        }
      }
    }
  }
}
```
