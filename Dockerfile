FROM golang:1.16.0

ARG KUDZU_DEBUG
ARG KUDZU_CORS_ORIGIN

RUN go get github.com/githubnemo/CompileDaemon
RUN go install github.com/go-delve/delve/cmd/dlv@latest

COPY ./kudzu /kudzu
COPY ./kudzu-cli /kudzu-cli

WORKDIR /kudzu-cli
RUN go mod download && \
go build -o kudzu-cli cmd/kudzu-cli/main.go && \
mv kudzu-cli /usr/local/bin

WORKDIR /kudzu
RUN go mod download

# ENTRYPOINT CompileDaemon --build="dlv debug --headless --listen=:2345 --log --continue --accept-multiclient" --command=./__debug_bin
COPY ./scripts/kudzu-wrapper /usr/local/bin
ENTRYPOINT [ "kudzu-wrapper" ]
