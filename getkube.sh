rm -r -f wip
rm -r -f src
mkdir src
mkdir wip
mkdir wip/bin
export VERSION=v1.11.3
curl -L -k https://dl.k8s.io/$VERSION/kubernetes-node-windows-amd64.tar.gz -o /tmp/kubernetes.tar.gz
(cd src;tar xvzf /tmp/kubernetes.tar.gz )
cp src/kubernetes/node/bin/* wip/bin
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ../content/kube_$VERSION.ign bin)
$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ls content/kube_$VERSION.ign
rm -r -f wip/*
rm -r -f src


