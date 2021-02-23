FROM golang:1.16.0

COPY ./kudzu /kudzu
COPY ./kudzu-cli /kudzu-cli

RUN go get github.com/githubnemo/CompileDaemon
RUN go install github.com/go-delve/delve/cmd/dlv@latest

WORKDIR /kudzu-cli
RUN go mod download && \
go build -o kudzu-cli cmd/kudzu-cli/main.go && \
mv kudzu-cli /usr/local/bin

WORKDIR /kudzu
RUN go mod download

# ENTRYPOINT CompileDaemon --build="dlv debug --headless --listen=:2345 --log --continue --accept-multiclient" --command=./__debug_bin
ENTRYPOINT cd ./plugins && \
go build -buildmode=plugin -gcflags='all=-N -l' -o ../.plugins/page.so page.go && \
cd ./.. && \
dlv debug --headless --listen=:2345 --log --continue --accept-multiclient
