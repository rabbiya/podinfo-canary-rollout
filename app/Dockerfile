FROM golang:1.23-alpine AS build
RUN apk add --no-cache git
RUN git clone --depth 1 --branch 6.7.1 https://github.com/stefanprodan/podinfo.git /src
WORKDIR /src
RUN CGO_ENABLED=0 GOOS=linux go build -o /podinfo ./cmd/podinfo

FROM public.ecr.aws/lambda/provided:al2023

COPY --from=build --chmod=755 /podinfo /var/task/podinfo

WORKDIR /var/task

ENV PORT=8080

CMD ["./podinfo"]
