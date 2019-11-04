FROM alpine:latest
COPY ./consul-template /usr/local/bin/consul-template
COPY ./env.tpl /home/env.tpl
RUN mkdir /var/log/adhoc-logs

CMD ["/bin/sh", "-c", "consul-template -consul-addr=$CONSUL_ADDR -template=/home/env.tpl:/app/.env -retry=10s -log-level=debug > /var/log/adhoc-logs/consul-template.log 2>&1" ]
