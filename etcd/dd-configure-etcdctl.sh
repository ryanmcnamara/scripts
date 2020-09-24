#!/bin/bash
echo "not intended to be run from this file"
exit 1

source /etc/etcd/environment
export ETCD_CERT_FILE=/var/lib/etcd/pki/etcd.pem
export ETCD_KEY_FILE=/var/lib/etcd/pki/etcd-key.pem
export ETCD_TRUSTED_CA_FILE=/var/lib/etcd/pki/etcd-ca.pem
export ETCDCTL_API=3

etcdctl --key=$ETCD_KEY_FILE --cert=$ETCD_CERT_FILE --cacert=$ETCD_TRUSTED_CA_FILE --endpoints=$ETCDCTL_ENDPOINTS endpoint health
