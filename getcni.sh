export VERSION=0.3.1
rm -r -f wip
mkdir wip
mkdir wip/bin
mkdir wip/cni
cat < wip/cni/10-ovn-kubernetes.conf << EOL
{"cniVersion":"0.3.1","name":"ovn-kubernetes","type":"ovn-k8s-cni-overlay","ipam":{},"dns":{}}
EOL
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ../content/ovs_$VERSION.ign bin)
$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ls content/ovs_$VERSION.ign
pwd
rm -r -f wip/bin



