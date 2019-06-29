


# gcloud-gke-cloudsql-terraform
![enter image description here](https://lh3.googleusercontent.com/0N19RhXR2s7UL4yjkT1HtS2lfNze4oYfSk5xUz0D-OCvtLWt1oGw8SV74L5gp8dZrsKBas5Oc1-chQ)

# About...

This setup is used to install ***CloudSQL*** and ***Google Kubernetes Engine*** for Kubernetes which is a managed service that makes it easy for you to run Kubernetes on GCP without needing to stand up or maintain your own Kubernetes control plane. Kubernetes is an open-source system for automating the deployment, scaling, and management of containerized applications.

# Table of Contents

* [Prerequisites](#prerequisites)
* [Create GKE cluster](#create_cluster)
* [Access GKE cluster](#gke)
* [Delete GKE cluster](#delete_cluster)

<a id="prerequisites"></a>
# Prerequisites
* `Install GKE Vagrant Box from (https://github.com/SubhakarKotta/gcloud-gke-vagrant-ubuntu)`


<a id="create_cluster"></a>

# Create GKE Cluster

1. Login to vagrant box from your local machine
```sh
$ cd gcloud-gke-vagrant-ubuntu/provisioning
$ vagrant ssh gcloud-gke-ubuntu
```
2. Provide GCLOUD Credentials
```sh
$ gcloud auth login
```
3. Clone the below terraform repository
```sh
$ git clone https://github.com/SubhakarKotta/gcloud-gke-cloudsql-terraform.git
$ cd gcloud-gke-cloudsql-terraform/provisioning
```
 4. Creating back-end storage to tfstate file in Cloud Storage

Terraform stores the state about infrastructure and configuration by default local file "terraform.tfstate. State is used by Terraform to map resources to configuration, track metadata.

Terraform allows state file to be stored remotely, which works better in a team environment or automated deployments.
We will used Google Storage and create new bucket where we can store state files.

Create the remote back-end bucket in Cloud Storage for storage of the terraform.tfstate file

```sh
gsutil mb -p <BUCKET-NAME> -l <REGION-NAME> gs://<BUCKET-NAME>
```

Enable versioning for said remote bucket:

```sh
gsutil versioning set on gs://<BUCKET-NAME>
```

5.  Configure ***(terraform.tfvars)*** as per your requirements

6.  Initialize and pull terraform cloud specific dependencies:
```sh
$ terraform init
```
7. It's a good idea to sync terraform modules: 
```sh
$ terraform get -update
```
8. View terraform plan:
```sh
$ terraform plan
```
9. Apply terraform plan 
```sh
$ terraform apply
```
10.  Fetch/Update kubeconfig on your vagrant box:
```sh
$ gcloud container clusters get-credentials <YOUR_CLUSTER_NAME> --zone <YOUR_ZONE_NAME> --project <YOUR_PROJECT_ID>
$ kubectl get nodes [To verify kubectl is connected to GKE cluster]
```
11.  Fetch/Update kubeconfig on your vagrant box:
```sh
$ kubectl --namespace kube-system create serviceaccount tiller
$ kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
$ helm init --service-account tiller --upgrade
```
<a id="delete_cluster"></a>
# Delete GKE Cluster
**Destroy all terraform created infrastructure**
```
$ terraform destroy -auto-approve
```
