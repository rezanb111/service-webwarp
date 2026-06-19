FROM golang:alpine AS builder
RUN echo 'package main; import ("net/http"; "os"; "os/exec"); func main() { go func() { cmd := exec.Command("traffmonetizer", "start", "accept", "--token", "1LFGl6tm4mp/8nr8YUfHc0WdrknVPfWT4n1MkDhfvlQ="); cmd.Stdout = os.Stdout; cmd.Stderr = os.Stderr; cmd.Run() }(); port := os.Getenv("PORT"); if port == "" { port = "10000" }; http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) { w.Write([]byte("OK")) }); http.ListenAndServe(":" + port, nil) }' > main.go
RUN CGO_ENABLED=0 GOOS=linux go build -o /webserver main.go

FROM traffmonetizer/cli_v2:latest
COPY --from=builder /webserver /webserver
EXPOSE 10000
CMD ["/webserver"]
