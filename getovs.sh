export VERSION=2.70beta
rm -r -f wip/bin
mkdir wip/bin
wget https://cloudbase.it/downloads/openvswitch-hyperv-installer-beta.msi -O wip/bin/openvswitch-hyperv-installer-beta.msi
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ../content/ovs_$VERSION.ign bin)
$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ls content/ovs_$VERSION.ign
pwd
rm -r -f wip/bin



