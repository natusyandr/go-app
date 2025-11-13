FROM golang:1.24.6-alpine

WORKDIR /app
COPY . .

RUN go build -o nat-go-app .

EXPOSE 4444
CMD ["./nat-go-app"]
