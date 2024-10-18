# Use the official Golang image as the base image
FROM golang:1.23-alpine

RUN apk update && apk upgrade 
RUN go env -w GOPROXY=direct
RUN apk add --no-cache git
RUN apk --no-cache add ca-certificates
# add git username and email
RUN git config --global user.email "marco.zingoni@gmail.com"
RUN git config --global user.name "zingazzi"
# fix fatal: could not read Username for 'https://github.com': terminal prompts disabled Confirm the import path was entered correctly
RUN git credential-cache exit


# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go application
RUN go build -o main .

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
CMD ["./main"]