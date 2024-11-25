FROM rust:1.82.0-alpine3.20 AS builder

WORKDIR /app

RUN apk add --no-cache musl-dev openssl-dev

COPY . .

ARG GIT_HASH=dev
ENV OPENSSL_DIR=/usr RUSTFLAGS=-Ctarget-feature=-crt-static
RUN cargo build --release --bin redlib

FROM alpine:3.20

RUN apk add --no-cache libgcc \
    && adduser --home /nonexistent --no-create-home --disabled-password redlib

USER redlib

# Tell Docker to expose port 8080
EXPOSE 8080

# Run a healthcheck every minute to make sure redlib is functional
HEALTHCHECK --interval=1m --timeout=3s CMD wget --spider -q http://localhost:8080/settings || exit 1

COPY --from=builder /app/target/release/redlib /usr/local/bin/

CMD ["redlib"]
