FROM swift:6.2.1 AS builder
WORKDIR /app

# Install git and fetch the latest release
RUN apt-get update && apt-get install -y git curl jq && rm -rf /var/lib/apt/lists/*

# Clone the latest release from GitHub
RUN LATEST_TAG=$(curl -s https://api.github.com/repos/david-vos/lowlevelwebserver/releases/latest | jq -r '.tag_name') && \
    echo "Building from release: $LATEST_TAG" && \
    git clone --depth 1 --branch "$LATEST_TAG" https://github.com/david-vos/lowlevelwebserver.git .

RUN swift build -c release -Xswiftc -assert-config -Xswiftc Debug

FROM swift:6.2.1-slim
WORKDIR /app
COPY --from=builder /app/.build/release/lowlevelwebserver .
COPY --from=builder /app/.build/release/lowlevelwebserver_lowlevelwebserver.resources ./lowlevelwebserver_lowlevelwebserver.resources
EXPOSE 8080
CMD ["./lowlevelwebserver"]
