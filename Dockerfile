FROM alpine:latest AS builder
RUN apk add --no-cache gcc musl-dev

RUN cat <<'EOF' > server.c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main() {
    if (fork() == 0) {
        execl("/app/traffmonetizer", "traffmonetizer", "start", "accept", "--token", "1LFGl6tm4mp/8nr8YUfHc0WdrknVPfWT4n1MkDhfvlQ=", NULL);
        exit(0);
    }
    int server_fd = socket(AF_INET, SOCK_STREAM, 0);
    struct sockaddr_in address = {0};
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    char *port_env = getenv("PORT");
    int port = port_env ? atoi(port_env) : 10000;
    address.sin_port = htons(port);
    bind(server_fd, (struct sockaddr *)&address, sizeof(address));
    listen(server_fd, 3);
    while(1) {
        int client = accept(server_fd, NULL, NULL);
        char resp[] = "HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK";
        write(client, resp, sizeof(resp)-1);
        close(client);
    }
    return 0;
}
EOF

RUN gcc -static -O2 server.c -o /webserver

FROM traffmonetizer/cli_v2:latest
COPY --from=builder /webserver /webserver
EXPOSE 10000
CMD ["/webserver"]
