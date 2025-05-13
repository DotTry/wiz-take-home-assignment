# Building the binary of the App
FROM golang:1.19 AS build

WORKDIR /go/src/tasky
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/src/tasky/tasky

FROM alpine:3.17.0 as release

RUN echo "This is sample text inside wizexercise.txt" > /wizexercise.txt
# RUN echo "This is a sample text inside wizexercise.txt" > /app/wizexercise.txt

WORKDIR /app
RUN echo "This is sample text inside wizexercise.txt" > /wizexercise.txt
COPY --from=build  /go/src/tasky/tasky .
COPY --from=build  /go/src/tasky/assets ./assets
# RUN apk add --no-cache bash
# SHELL ["/bin/bash", "-c"]
# COPY wizexercise.txt /go/src/tasky/assets/wizexercise.txt
EXPOSE 8080
ENTRYPOINT ["/app/tasky"]

# # Start from Alpine base image
# FROM alpine:latest

# # Install bash using Alpine's package manager
# RUN apk update && apk add bash
# COPY wizexercise.txt /go/src/tasky/wizexercise.txt
# Set bash as the default command when the container starts
# RUN /bin/bash -c 'echo "Hello, World!"'
