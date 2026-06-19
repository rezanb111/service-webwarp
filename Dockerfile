FROM traffmonetizer/cli_v2:latest

USER root
RUN apt-get update && apt-get install -y python3 && rm -rf /var/lib/apt/lists/*

EXPOSE 10000

CMD python3 -m http.server 10000 & traffmonetizer start accept --token 1LFGl6tm4mp/8nr8YUfHc0WdrknVPfWT4n1MkDhfvlQ=
