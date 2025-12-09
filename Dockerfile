FROM swift:6.2.1 AS builder
WORKDIR /app
COPY . .
RUN swift build -c release -Xswiftc -assert-config -Xswiftc Debug

FROM swift:6.2.1-slim
WORKDIR /app
COPY --from=builder /app/.build/release/lowlevelwebserver .
COPY --from=builder /app/.build/release/lowlevelwebserver_lowlevelwebserver.resources ./lowlevelwebserver_lowlevelwebserver.resources
EXPOSE 8080
CMD ["./lowlevelwebserver"]
