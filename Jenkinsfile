pipeline {
  agent {
    kubernetes {
      //cloud 'kubernetes'
      label 'jenkins-slave-terraform-kubectl-helm-gcloud'
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: jenkins-slave-terraform-kubectl-helm-gcloud
    image: subhakarkotta/terraform-kubectl-helm-gcloud:0.11.14-v1.14.3-v2.13.1-250.0.0
    command: ['cat']
    tty: true
"""
    }
  }
    options {
        timeout(time: 2, unit: 'HOURS')
        ansiColor('xterm')
    }
    parameters {
        choice(
            choices: ['preview' , 'create' , 'show', 'preview-destroy' , 'destroy' , 'remove-state'],
            description: 'preview - to list the resources being created.  create - creates a new cluster.  show - list the resources of existing cluster.  preview-destroy - list the resources of existing cluster that will be destroyed. destroy - destroys the cluster',
            name: 'action')
        string(name: 'docker', defaultValue : 'YOUR_DOCKER_ACCOUNT>', description: "Provide your  Docker Account configured in global credentials.")   
        string(name: 'gcp', defaultValue : '<YOUR_GCP_ACCOUNT>', description: "Provide your  GCP Credential ID (secretfile) from Global credentials.")
        string(name: 'cluster', defaultValue : '<YOUR_CLUSTER_NAME>', description: "Provide unique GKE Cluster name [non existing cluster in case of new].")
        string(name: 'state', defaultValue : '<YOUR_JSON_PATH>', description: "Provide the complete json path to remove particular state and this can be used to remove discrepancy in the saved state.")
        text(name: 'parameters', defaultValue : '', description: "By leaving this field as empty, default cluster will be created in the region US West [Oregon] (https://git.pega.io/projects/SM/repos/gcp-gke-terraform/browse/terraform.tfvars.template). Only the required parameters can be overridden by visiting the link (https://git.pega.io/projects/SM/repos/gcp-gke-terraform/browse/provisioning/terraform.tfvars.template). You can create a cluster in different region by overriding the parameters region | azs | key_name | elb_zone_id.")
        text(name: 'pega', defaultValue : '', description: "By leaving this field as empty, default pega will be installed and deployed with latest build using values defined in the template (https://github.com/scrumteamwhitewalkers/terraform-pega-modules/blob/master/templates/gke_values.tpl).  As per requirement if any of the value needs to be changed in the template eks_values.tpl then complete  template needs to be provided in this text box by copying exact YAML format with modified values")
    }

    environment {
       PLAN_NAME= "${cluster}-gke-terraform-plan"
       TFVARS_FILE_NAME= "${cluster}-gke-terraform.tfvars"
       PEGA_VALUES_YAML_TEMPLATE= ".terraform/modules/pega/templates/gke_values.tpl"
       TF_LOG="TRACE"
       TF_LOG_PATH="./${cluster}.log"
    }   
    
    stages {
        stage('Set Build Display Name') {
            steps {
                script {
                    currentBuild.displayName = "#" + env.BUILD_NUMBER + " " + params.action + "-gke-" + params.cluster
                    currentBuild.description = "Preview/Create/Validate/Destroy GKE Cluster and Postgres database"
                }
            }
        }
        stage('Create gke_values.tpl') {
            when {
                expression { params.pega != '' && params.pega != null }
            }
            steps {
              container('jenkins-slave-terraform-kubectl-helm-awscli'){ 
                    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
                         dir ("provisioning") { 
                             echo "${pega}"
                             sh 'rm -f ${PEGA_VALUES_YAML_TEMPLATE}'
                             writeFile file: "${PEGA_VALUES_YAML_TEMPLATE}", text: "${pega}"
                         }
                     }
                 }
             }
         } 
        stage('Create terraform.tfvars') {
            steps {
              container('jenkins-slave-terraform-kubectl-helm-gcloud'){ 
                    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
                         dir ("provisioning") { 
                             echo "${parameters}"
                             writeFile file: "${TFVARS_FILE_NAME}", text: "${parameters}"
                             echo " ############ Cluster @@@@@ ${cluster} @@@@@ #############"
                             echo " ############ Using @@@@@ ${TFVARS_FILE_NAME} @@@@@ #############"
                         }
                     }
               }
             }
         } 
        stage('versions') {
            steps {
                container('jenkins-slave-terraform-kubectl-helm-gcloud'){ 
                      wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
                            sh 'terraform version'
                            sh 'kubectl version'
                            sh 'helm version --client'
                            sh 'gcloud version'
                       }
                 }
             }
         }
        stage('init') {
            steps {
               container('jenkins-slave-terraform-kubectl-helm-gcloud'){ 
                   withCredentials([[$class: 'FileBinding', credentialsId: params.gcp, variable: 'GOOGLE_APPLICATION_CREDENTIALS']]){
                       wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
                            dir ("provisioning") { 
                                sh 'terraform init  -backend-config="prefix=${cluster}/terraform.tfstate"'
                                sh 'terraform output kubeconfig > ./kubeconfig_${cluster} || true'
                            }
                         }
                     }
                 }
             }
         }
        stage('remove-state') {
            when {
                expression { params.action == 'remove-state' }
            }
            steps {
               container('jenkins-slave-terraform-kubectl-helm-gcloud'){ 
                   withCredentials([[$class: 'FileBinding', credentialsId: params.gcp, variable: 'GOOGLE_APPLICATION_CREDENTIALS']]){
                       wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
                            dir ("provisioning") { 
                               sh 'terraform state rm ${state}'
                            }
                         }
                     }
                 }
             }
         } 
        stage('validate') {
            when {
                expression { params.action == 'preview' || params.action == 'create'  || params.action == 'destroy' }
             }
             steps {
                container('jenkins-slave-terraform-kubectl-helm-gcloud'){
                     withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: params.docker, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
                         withCredentials([[$class: 'FileBinding', credentialsId: params.gcp, variable: 'GOOGLE_APPLICATION_CREDENTIALS']]){
                             wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
                                 dir ("provisioning") { 
                                     sh 'gcloud auth activate-service-account --key-file ${gcp}'
                                     sh 'terraform validate -var docker_username=$USERNAME -var docker_password=$PASSWORD -var  name=${cluster} --var-file=${TFVARS_FILE_NAME}'
                                 }
                             }
                         }
                     }
                 }
             }
        }
        stage('preview') {
            when {
                expression { params.action == 'preview' }
            }
            steps {
               container('jenkins-slave-terraform-kubectl-helm-gcloud'){ 
                   withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: params.docker, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
                       withCredentials([[$class: 'FileBinding', credentialsId: params.gcp, variable: 'GOOGLE_APPLICATION_CREDENTIALS']]){
                           wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
                               dir ("provisioning") {
                                  sh 'terraform plan  -var docker_username=$USERNAME -var docker_password=$PASSWORD -var name=$cluster --var-file=${TFVARS_FILE_NAME}  -out=${PLAN_NAME}'
                                 }
                             }
                         }
                     }
                 }
             }
         }
        stage('create') {
            when {
                expression { params.action == 'create' }
            }
            steps {
                container('jenkins-slave-terraform-kubectl-helm-gcloud'){ 
                     withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: params.docker, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
                         withCredentials([[$class: 'FileBinding', credentialsId: params.gcp, variable: 'GOOGLE_APPLICATION_CREDENTIALS']]){
                             wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
                                dir ("provisioning") {
                                    sh 'terraform plan     -var docker_username=$USERNAME -var docker_password=$PASSWORD -var name=$cluster --var-file=${TFVARS_FILE_NAME}  -out=${PLAN_NAME}'
                                    sh 'terraform apply   -var docker_username=$USERNAME -var docker_password=$PASSWORD -var name=$cluster --var-file=${TFVARS_FILE_NAME} -auto-approve'
                                 }
                             }
                         }
                     }
                 }
             }
         }
        stage('show') {
            when {
                expression { params.action == 'show' }
            }
            steps {
                container('jenkins-slave-terraform-kubectl-helm-gcloud'){ 
                     withCredentials([[$class: 'FileBinding', credentialsId: params.gcp, variable: 'GOOGLE_APPLICATION_CREDENTIALS']]){
                         wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
                             dir ("provisioning") {
                                sh 'terraform show'
                             }
                        }
                    }
                 }
             }
         }
        stage('preview-destroy') {
            when {
                expression { params.action == 'preview-destroy' }
            }
            steps {
                  container('jenkins-slave-terraform-kubectl-helm-gcloud'){ 
                       withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: params.docker, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
                           withCredentials([[$class: 'FileBinding', credentialsId: params.gcp, variable: 'GOOGLE_APPLICATION_CREDENTIALS']]){
                               wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
                                   dir ("provisioning") {
                                       sh 'terraform plan -destroy -var docker_username=$USERNAME -var docker_password=$PASSWORD -var name=${cluster} --var-file=${TFVARS_FILE_NAME}'
                                     }
                                 }
                             }
                         } 
                     }
                }
            }
        stage('destroy') {
            when {
                expression { params.action == 'destroy' }
            }
            steps {
                container('jenkins-slave-terraform-kubectl-helm-gcloud'){ 
                     withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: params.docker, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
                         withCredentials([[$class: 'FileBinding', credentialsId: params.gcp, variable: 'GOOGLE_APPLICATION_CREDENTIALS']]){
                             wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
                                 dir ("provisioning") {
                                     sh 'terraform destroy -var docker_username=$USERNAME -var docker_password=$PASSWORD -var name=${cluster} --var-file=${TFVARS_FILE_NAME} -force'
                                     }
                                 }
                             }
                         }  
                     }
                 }
            }
         }
     }