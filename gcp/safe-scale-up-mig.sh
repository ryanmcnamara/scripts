#!/bin/bash

tmpFile="/tmp/dr_recovery.txt"

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

function setallnodegroupsizes {
    rm -f $tmpFile
    sourceFile=$1
    for i in $(seq 1 $(cat "$sourceFile" | jq '.items | length')); do
        cat "$sourceFile" | jq '.items['"$i"']' --compact-output > $tmpFile
        date
        name=$(cat $tmpFile | jq '.metadata.name')
        namespace=$(cat $tmpFile | jq '.metadata.namespace')
        echo namespace $namespace
        echo name $name

        largestSize=$(cat $tmpFile | jq -r '.status.gcp[].instanceGroupManager.targetSize' | sort -g | tail -n 1)

        if [ ! kubectl get nodegroup -n $namespace $name > /dev/null 2>&1 ]; then
            echo "nodegroup not found, will take no action, namespace: $namespace, name: $name"
        else
            echo "EXITING AS A SAFEGUARD, remove this exit to take action"
            exit 1
            echo "Scaling nodegroup -n $namespace $name to $largestSize per zone"
            scaleupnodegroup $namespace $name $largestSize
        fi
    done
}
