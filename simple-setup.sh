docker run -d \
    --net=host \
    gcr.io/google_containers/etcd:2.0.9 \
    /usr/local/bin/etcd \
        --addr=127.0.0.1:4001 \
        --bind-addr=0.0.0.0:4001 \
        --data-dir=/var/etcd/data

docker run -d  \
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

docker run -d \
   --net=host \
   --privileged \
   jetstack/hyperkube:v0.20.1 \
   /hyperkube proxy \
        --master=http://127.0.0.1:8080 \
        --v=2