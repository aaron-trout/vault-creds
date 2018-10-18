FROM golang:1.9-alpine as build
RUN apk add --no-cache git
ADD . /go/src/github.com/uswitch/vault-creds
WORKDIR /go/src/github.com/uswitch/vault-creds
ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GOBIN=/go/bin
RUN go get -v cmd/*.go
RUN go build \
      -ldflags "-X main.SHA=$(git rev-parse HEAD)" \
      -o /usr/local/bin/vaultcreds \
      cmd/*.go

FROM alpine:3.8
RUN apk add --no-cache ca-certificates
COPY --from=build /usr/local/bin/vaultcreds /usr/local/bin/vaultcreds
ENTRYPOINT ["/usr/local/bin/vaultcreds"]
CMD []
