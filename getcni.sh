export VERSION=0.3.1
rm -r -f wip
mkdir wip
mkdir wip/bin
mkdir wip/bin/metadata
mkdir wip/cni
touch wip/cni/10-ovn-kubernetes.conf
cat > wip/cni/10-ovn-kubernetes.conf << EOL
{"cniVersion":"0.3.1","name":"ovn-kubernetes","type":"ovn-k8s-cni-overlay","ipam":{},"dns":{}}
EOL
cp metadata/cni_$VERSION.metadata wip/bin/metadata/cni_$VERSION.metadata
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool um ../content/cni_$VERSION.ign bin/metadata/cni_$VERSION.metadata)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ../content/cni_$VERSION.ign bin/metadata)
$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ls content/cni_$VERSION.ign
cat wip/bin/metadata/cni_$VERSION.metadata
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ../content/cni_$VERSION.ign cni)
$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ls content/cni_$VERSION.ign
pwd
rm -r -f wip/bin

