FROM golang:1.23-alpine AS build
RUN apk add --no-cache git
RUN git clone --depth 1 --branch 6.7.1 https://github.com/stefanprodan/podinfo.git /src
WORKDIR /src
RUN CGO_ENABLED=0 GOOS=linux go build -o /podinfo ./cmd/podinfo

FROM public.ecr.aws/lambda/provided:al2023

COPY --from=build --chmod=755 /podinfo /podinfo

COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.8.4 /lambda-adapter /opt/extensions/lambda-adapter

ENV PORT=9898
ENV AWS_LWA_PORT=9898
ENV AWS_LWA_READINESS_CHECK_PATH=/healthz

ENTRYPOINT ["/podinfo"]
