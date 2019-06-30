apiVersion: v1
kind: Config
preferences: {}
current-context: ${kubeconfig_name}
contexts:
- context:
    cluster: ${kubeconfig_name}
    namespace: default
  name: ${kubeconfig_name}
clusters:
- cluster:
    server: https://${endpoint}
    certificate-authority-data: ${cluster_ca}
  name: ${kubeconfig_name}
users:
- name: ${user_name}
  user:
    password: ${user_password}
    username: ${user_name}
    client-certificate-data: ${client_cert}
    client-key-data: ${client_cert_key}