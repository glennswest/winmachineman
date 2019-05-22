FROM registry.svc.ci.openshift.org/openshift/release:golang-1.10 as builder
RUN go get github.com/glennswest/winmachineman/winmachineman
WORKDIR /go/src/github.com/glennswest/winmachineman/winmachineman
RUN  go get -d -v
RUN  CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="-w -s" -o /go/bin/winmachineman

FROM scratch
VOLUME /tmp
WORKDIR /root/
COPY --from=builder /go/bin/winmachineman /go/bin/winmachineman
COPY commit.id commit.id
EXPOSE 8080
ENTRYPOINT ["/go/bin/winmachineman"]
