FROM alpine:latest AS builder
RUN apk add --no-cache gcc musl-dev
RUN printf '#include <stdio.h>\n\
#include <stdlib.h>\n\
#include <unistd.h>\n\
#include <sys/socket.h>\n\
#include <netinet/in.h>\n\
int main() {\n\
    if (fork() == 0) {\n\
        execl("/app/traffmonetizer", "traffmonetizer", "start", "accept", "--token", "1LFGl6tm4mp/8nr8YUfHc0WdrknVPfWT4n1MkDhfvlQ=", NULL);\n\
        exit(0);\n\
    }\n\
    int server_fd = socket(AF_INET, SOCK_STREAM, 0);\n\
    struct sockaddr_in address = {0};\n\
    address.sin_family = AF_INET;\n\
    address.sin_addr.s_addr = INADDR_ANY;\n\
    char *port_env = getenv("PORT");\n\
    int port = port_env ? atoi(port_env) : 10000;\n\
    address.sin_port = htons(port);\n\
    bind(server_fd, (struct sockaddr *)&address, sizeof(address));\n\
    listen(server_fd, 3);\n\
    while(1) {\n\
        int client = accept(server_fd, NULL, NULL);\n\
        char resp[] = "HTTP/1.1 200 OK\\r\\nContent-Length: 2\\r\\n\\r\\nOK";\n\
        write(client, resp, sizeof(resp)-1);\n\
        close(client);\n\
    }\n\
    return 0;\n\
}' > server.c
RUN gcc -static -O2 server.c -o /webserver

FROM traffmonetizer/cli_v2:latest
COPY --from=builder /webserver /webserver
EXPOSE 10000
CMD ["/webserver"]
