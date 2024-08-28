# Specify the platform for the build stage
FROM --platform=linux/amd64 rust:1.80-slim AS builder

# Set the working directory inside the container
WORKDIR /usr/src/function

# Install necessary tools and the musl target
RUN apt-get update &&  \
    apt-get install -y musl-tools && \
    rustup target add x86_64-unknown-linux-musl

# Copy the Cargo.toml and Cargo.lock files
COPY Cargo.toml Cargo.lock ./

# Copy the src directory
COPY src/ ./src/

# Build the application
RUN cargo build --release --target x86_64-unknown-linux-musl

# Use a minimal image to run the application
FROM --platform=linux/amd64 public.ecr.aws/lambda/provided:al2

# Copy the compiled binary from the builder stage
COPY --from=builder /usr/src/function/target/x86_64-unknown-linux-musl/release/function /bootstrap

# Lambda's entry point expects a /bootstrap executable
ENTRYPOINT ["/bootstrap"]
