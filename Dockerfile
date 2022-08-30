FROM golang:1.19.0-bullseye AS builder
COPY . /grpc-go
RUN cd /grpc-go/examples && go build -o server features/health/server/main.go

RUN cd / && git clone --depth=1 https://github.com/grpc-ecosystem/grpc-health-probe && cd grpc-health-probe && git checkout v0.4.12 && go build -o grpc-health-probe

FROM debian:bullseye
COPY --from=builder /grpc-go/examples/server ./
COPY --from=builder /grpc-health-probe/grpc-health-probe ./
CMD ["./server"]
