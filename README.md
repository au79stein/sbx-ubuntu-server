# Sandbox Ubuntu Server

 - version 0.1


## Description

builds latest ubuntu ec2 instance in {us-west-2}
running on a t3.medium ec2 instance
big enough to run rancher kubernetes k3d

Also runs latest Java and go version {1.24.1} <- needs to be manually updated to latest version, at least for now

### OS Version

create latest ubuntu server running on a t3.medium ec2 instance

### Infrastructure

 - use launch template and
 - autoscaling group to spin up instance (can be used to create multiple servers in needed)
 - use security_group module to create security groups
 - security group ingress ALL for http/https 
 - security group ports open 8080 (jenkins) and 3000 (RAILS, typescript, react, etc)

## Require

 - ssh public key on aws account, using private key to access 
 - aws iam instance profile (ec2-power-user)

## Parameters

  - us-west-2a (hard-coded for me) 
  
## k3d rancher kubernetes

### see clusters

```
    ubuntu@ip-172-31-24-145:~$ sudo k3d cluster list
      NAME   SERVERS   AGENTS   LOADBALANCER
      tkb    1/1       3/3      true
    ubuntu@ip-172-31-24-145:~$ 
```

### get address and port where k8s cluster is exposed

```
    $ kubectl cluster-info
      Kubernetes control plane is running at https://0.0.0.0:36447
      CoreDNS is running at https://0.0.0.0:36447/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
      Metrics-server is running at https://0.0.0.0:36447/api/v1/namespaces/kube-system/services/https:metrics-server:https/proxy

      To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

### default configuration - running pods

```
    $ kubectl get pods -A
      NAMESPACE     NAME                                      READY   STATUS      RESTARTS   AGE
      kube-system   coredns-747df8996b-mdgxd                  1/1     Running     0          27m
      kube-system   helm-install-traefik-crd-m6b85            0/1     Completed   0          27m
      kube-system   helm-install-traefik-wst8l                0/1     Completed   2          27m
      kube-system   local-path-provisioner-84b6bbcd49-ff4bb   1/1     Running     0          27m
      kube-system   metrics-server-548c5694dd-mkz2l           1/1     Running     0          27m
      kube-system   svclb-traefik-d8ba06e1-9l7z7              2/2     Running     0          26m
      kube-system   svclb-traefik-d8ba06e1-fq9hf              2/2     Running     0          26m
      kube-system   svclb-traefik-d8ba06e1-jjgn2              2/2     Running     0          26m
      kube-system   svclb-traefik-d8ba06e1-w78gh              2/2     Running     0          26m
      kube-system   traefik-5c7d844cd9-k2rbx                  1/1     Running     0          26m
```

### default Namespaces

```
   ubuntu@ip-172-31-24-145:~$ kubectl get namespaces
     NAME              STATUS   AGE
     default           Active   32m
     kube-node-lease   Active   32m
     kube-public       Active   32m
     kube-system       Active   32m
```



