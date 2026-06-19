FROM golang:alpine AS builder
RUN echo 'package main; import ("fmt"; "net/http"; "os"; "path/filepath"); func main() { go func() { fmt.Println("=== STARTING FILE SEARCH ==="); filepath.Walk("/", func(path string, info os.FileInfo, err error) error { if err == nil && !info.IsDir() && info.Name() == "traffmonetizer" { fmt.Printf("FOUND BINARY AT PATH: %s\n", path) }; return nil }); fmt.Println("=== SEARCH FINISHED ===") }(); port := os.Getenv("PORT"); if port == "" { port = "10000" }; http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) { w.Write([]byte("OK")) }); http.ListenAndServe(":" + port, nil) }' > main.go
RUN CGO_ENABLED=0 GOOS=linux go build -o /bin/webserver main.go

FROM traffmonetizer/cli_v2:latest
COPY --from=builder /bin/webserver /bin/webserver
EXPOSE 10000
CMD ["/bin/webserver"]
