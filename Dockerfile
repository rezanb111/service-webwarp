FROM traffmonetizer/cli_v2:latest

EXPOSE 10000

CMD (while true; do echo -e "HTTP/1.1 200 OK\n\n Ready" | nc -lk -p 10000; done) & traffmonetizer start accept --token 1LFGl6tm4mp/8nr8YUfHc0WdrknVPfWT4n1MkDhfvlQ=
