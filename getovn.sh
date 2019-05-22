rm -r -f wip/ovn-kubernetes
rm -r -f wip/bin
mkdir wip/bin
mkdir wip/bin/metadata
git clone https://github.com/glennswest/ovn-kubernetes  wip/ovn-kubernetes
cd wip/ovn-kubernetes;export VERSION=`git rev-parse --short HEAD`;cd ../..
(cd wip/ovn-kubernetes;cd go-controller;make clean;make windows)
cp wip/ovn-kubernetes/go-controller/_output/go/windows/*.exe wip/bin
cp -f files/ovn_$VERSION/bin/* wip/bin
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ../content/ovn_$VERSION.ign bin)
cp metadata/ovn_$VERSION.metadata wip/bin/metadata/ovn_$VERSION.metadata
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool um ../content/ovn_$VERSION.ign bin/metadata/ovn_$VERSION.metadata)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ../content/ovn_$VERSION.ign bin/metadata)
$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ls content/ovn_$VERSION.ign
pwd
#rm -r -f wip/bin
#rm -r -f wip/ovn-kubernetes

