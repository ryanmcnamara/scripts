#!/bin/bash

function scaleupmig {
    name=$1
    zone=$2
    size=$3
    zone=$(echo $zone | sed "s/.*\\///")
    echo "name $name"
    echo "zone $zone"
    echo "size $size"
    currentSize=$(gcloud compute instance-groups managed   describe  $name  --zone $zone --format=json | jq .targetSize)
    echo "current size $currentSize"
    if [ "$currentSize" -gt "$size" ]; then
        echo "current size is greater than new size"
        echo "current size $currentSize"
        echo "new size $size"
        exit 1
    fi
    gcloud compute instance-groups managed resize $name --size $size --zone $zone
}

function scaleupnodegroup {
    namespace=$1
    name=$2
    sizePerZone=$3

    kubectl get nodegroups -n $namespace  $name   -o json | jq -r '.status.gcp[].instanceGroupManager | "\(.name) \(.zone)"'

    for migName migZone in $(kubectl get nodegroups -n $namespace  $name   -o json | jq -r '.status.gcp[].instanceGroupManager | "\(.name) \(.zone)"'); do
        scaleupmig $migName $migZone $sizePerZone
    done
}
