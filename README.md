
## Kubernetes Simple
This is just repository for showing a demo of simple [kubernetes](https://kubernetes.io/) setup to understand how it works.

## Install
1. [Docker](https://www.docker.com/)
2. [Kubectl](https://kubernetes.io/docs/user-guide/kubectl-overview/)
```
wget https://storage.googleapis.com/kubernetes-release/release/v0.20.1/bin/linux/amd64/kubectl
chmod u+x kubetctl
sudo  mv kubectl /usr/local/bin/
```

## Steps
#### 1.  Start [etcd](https://github.com/coreos/etcd)
```
docker run -d \
    --net=host \
    gcr.io/google_containers/etcd:2.0.9 \
    /usr/local/bin/etcd \
        --addr=127.0.0.1:4001 \
        --bind-addr=0.0.0.0:4001 \
        --data-dir=/var/etcd/data
```

*Etcd* is a key-value store designed for strong consistency and high-availability. Kubernetes use this to distribute information accross the cluster.

#### 2.  Start kubernetes master
```
docker run -d \
    --net=host \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /sys:/sys \
    --pid=host \
    jetstack/hyperkube:v0.20.1 \
    /hyperkube kubelet \
        --api_servers=http://localhost:8080 \
        --v=2 \
        --address=0.0.0.0 \
        --enable_server \
        --hostname_override=127.0.0.1 \
        --config=/etc/kubernetes/manifests-multi \
        --pod-infra-container-image="gcr.io/google_containers/pause:0.8.0"
```

Kubelet container will be run. Also, kubelet will run the cluster-wide component that form the Kubernetes master control plane, which consists of:
* API Server
* Schedule
* Controller Manager

#### 3. Start service proxy
```
docker run -d \
   --net=host \
   --privileged \
   jetstack/hyperkube:v0.20.1 \
   /hyperkube proxy \
        --master=http://127.0.0.1:8080 \
        --v=2
```

#### 4. Test by running sample image in pod with [kubectl](https://kubernetes.io/docs/user-guide/kubectl-overview/)

```
kubectl -s http://localhost:8080 run-container todopod --image=dockerinpractice/todo --port=8000
```

#### 5. Open your browser with ip addresss, port 8080 from
`kubectl describe pods [pod_name]`

## How to run
1. run `./simple-setup.sh`
2. run `kubectl -s http://localhost:8080 run-container todopod --image=dockerinpractice/todo --port=8000`