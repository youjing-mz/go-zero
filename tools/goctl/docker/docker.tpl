FROM golang:{{.Version}}alpine AS builder

LABEL stage=gobuilder

ENV CGO_ENABLED 0
{{if .Chinese}}ENV GOPROXY https://goproxy.cn,direct
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
{{end}}{{if .HasTimezone}}
RUN apk update --no-cache && apk add --no-cache tzdata
{{end}}
WORKDIR /build

ADD go.mod .
ADD go.sum .
RUN go mod download
COPY . .
COPY {{.GoRelPath}}/etc/run.sh /app/run.sh
{{if .Argument}}COPY {{.GoRelPath}}/etc /app/etc
{{end}}RUN go build -o /app/{{.ExeFile}} {{.GoMainFrom}}


FROM ubuntu:22.04

RUN apt-get update && apt-get install -y bash

# 创建 /tmp/cores 目录
RUN mkdir -p /tmp/cores

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
{{if .HasTimezone}}COPY --from=builder /usr/share/zoneinfo/{{.Timezone}} /usr/share/zoneinfo/{{.Timezone}}
ENV TZ {{.Timezone}}
{{end}}
WORKDIR /app
COPY --from=builder /app/run.sh /app/run.sh
COPY --from=builder /app/{{.ExeFile}} /app/{{.ExeFile}}{{if .Argument}}
COPY --from=builder /app/etc /app/etc{{end}}
RUN chmod 777 /app/run.sh
{{if .HasPort}}
EXPOSE {{.Port}}
{{end}}
CMD ["./run.sh", "./{{.ExeFile}}"{{.Argument}}]
