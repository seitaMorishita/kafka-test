#!/bin/groovy

// CHANGEME
// Change flow as you like
// env: Virtual environment name. You can define any number of enviroments
// clusterId: CaaS cluster ID to which you want to deploy
// namespace: Kubernetes namespace. By default get from job URL
// image: build => build new image, promote => promote image from previous environment
def FLOW = [
	[env: "beta",    clusterId: "jpe1-caas1-beta1", namespace: "${env.JOB_NAME.split('/')[3]}", image: "build"],
	[env: "release", clusterId: "jpe1-caas1-beta1", namespace: "${env.JOB_NAME.split('/')[3]}", image: "promote"]
]
def ENV_LIST = FLOW.collect{ it.env }
def flow

pipeline {
	agent {
		label 'slave'
	}
	options {
		ansiColor('xterm')
		buildDiscarder(logRotator(numToKeepStr: '20'))
		timeout(time: 30, unit: 'MINUTES')
		timestamps()
	}
	parameters {
		choice(choices: ENV_LIST, description: 'Please choose environment you want to deploy!', name: 'ENVIRONMENT')
		string(name: 'APP_REPO_BRANCH', description: 'branch or tag name for the Application repository', defaultValue: 'master')
	}
	environment {
		// Get app name from Jenkins job url.
		// e.g, /Tenant/caas-pipeline/Namespace/caas-jenkins/Apps/nginx/
		// You can change APP_NAME if you want
		APP_NAME = "${env.JOB_NAME.split('/')[5]}"

		// CHANGEME
		// Configurations for Application repository
		APP_REPO_URL     = 'ssh://git@git.rakuten-it.com:7999/caaspipeline/sample-app.git'
		APP_REPO_CREDS   = 'sample-app-git-access-key'
		APP_CHECKOUT_DIR = 'app'

		MANIFEST_FILE = 'resource.yaml'
	}
	stages {
		stage('Initialization') {
			steps {
				script {
					flow = new com.rakuten.cpd.Flow(this, FLOW)
					flow.setCurrentEnv(params.ENVIRONMENT)
					env.K8S_CLUSTER_ID = flow.getClusterId()
					env.K8S_NAMESPACE  = flow.getNamespace()
				}
			}
		}

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

		stage('Retrieve IAM token from user session') {
			steps {
				script {
					env.K8S_TOKEN = cpd.getIAMToken()
				}
			}
		}

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

		stage('Promote image') {
			when {
				expression { flow.isPromoteImage() }
			}
			steps {
				script {
					// Retag target tag with new env name suffix
					// promoteImage method expects that your docker image tag ends with environment name
					env.DOCKER_IMAGE = cpd.promoteImage(flow, env.APP_NAME)
				}
			}
		}

		stage ('Build resource yaml') {
			steps {
				script {
					// Update image url with built image url in above stage
					// Build Kubernetes resource declaration for the env that specified by the parameters
					dir("overlays/${params.ENVIRONMENT}") {
						sh label: 'build resource.yaml with kustomize', script: """
							${KUSTOMIZE_HOME}/kustomize edit set image ${APP_NAME}=${env.DOCKER_IMAGE}
							${KUSTOMIZE_HOME}/kustomize build --output ../../${MANIFEST_FILE}
						"""
					}

					env.DEPLOY_NAME = cpd.getNameFromManifest(file: env.MANIFEST_FILE, kind: 'Deployment')
				}
			}
			post {
				success {
					archiveArtifacts env.MANIFEST_FILE
				}
			}
		}

		stage ('Apply manifests') {
			steps {
				script {
					def APPLY_STATUS = cpd.kubectl("apply -f ${MANIFEST_FILE}")
					if (APPLY_STATUS > 0) {
						error("\u001B[31m Applyment is failed. Please check syntax of resource yaml, your permission or try to logout/login Jenkins to refresh token.\u001B[0m ")
					}
				}
			}
		}

		stage('Watch the status of the rollout') {
			when { expression { return env.DEPLOY_NAME } }
			steps {
				script {
					// Wait until deployment become ready
					def ROLLOUT_STATUS = cpd.kubectl("rollout status deployment ${DEPLOY_NAME}")
					if (ROLLOUT_STATUS > 0) {
						error("\u001B[31m Rollout deployment ${DEPLOY_NAME} is failed.\nref \u001B[0m https://kubernetes.io/docs/tasks/debug-application-cluster/debug-application/ ")
						cpd.kubectl("get events | grep ${DEPLOY_NAME}")
					}
				}
			}
			post {
				aborted {
					script {
						echo "\u001B[31m Rollout deployment ${DEPLOY_NAME} is timeout.\nref \u001B[0m https://kubernetes.io/docs/tasks/debug-application-cluster/debug-application/ "
						cpd.kubectl("get events | grep ${DEPLOY_NAME}")
					}
				}
			}
		}
	}
	post {
		always {
			// Clean up workspace to avoid mixing with the results of previous builds
			// If you want to debug, comment out following line please
			cleanWs()
		}
	}
}
