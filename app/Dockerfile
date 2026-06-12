# Stage 1: Podinfo ko source se build karo (assignment requirement: reproducible build)
FROM golang:1.23-alpine AS build
RUN apk add --no-cache git
RUN git clone --depth 1 --branch 6.7.1 https://github.com/stefanprodan/podinfo.git /src
WORKDIR /src
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-s -w" -o /podinfo ./cmd/podinfo

# Stage 2: Minimal, non-root final image (assignment requirement: hardening)
FROM gcr.io/distroless/static-debian12:nonroot

# Lambda Web Adapter: ye Podinfo (normal HTTP server) ko Lambda pe chalata hai
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.8.4 /lambda-adapter /opt/extensions/lambda-adapter

COPY --from=build /podinfo /podinfo

ENV PORT=9898 \
    AWS_LWA_PORT=9898 \
    AWS_LWA_READINESS_CHECK_PATH=/healthz

USER nonroot
EXPOSE 9898
ENTRYPOINT ["/podinfo"]
