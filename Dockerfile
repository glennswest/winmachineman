FROM registry.svc.ci.openshift.org/openshift/release:golang-1.10 as builder
RUN go get github.com/glennswest/winmachineman/winmachineman
WORKDIR /go/src/github.com/glennswest/winmacineman/winmachineman
RUN  CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -ldflags '-extldflags "-static"' .

FROM scratch
VOLUME /tmp
WORKDIR /root/
COPY --from=builder /go/src/github.com/glennswest/winoperator/winmachineman/winmachineman /root/winmachineman
COPY commit.id commit.id
ENTRYPOINT ["/root/winmachineman"]
