FROM rust:1.75 as builder
WORKDIR /app
COPY . .
RUN cargo install --path .

FROM public.ecr.aws/lambda/provided:al2
COPY --from=builder /usr/local/cargo/bin/bootstrap ${LAMBDA_RUNTIME_DIR}/bootstrap
CMD ["bootstrap.handler"]