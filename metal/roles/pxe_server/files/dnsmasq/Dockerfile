FROM alpine:3.19

RUN apk --no-cache add dnsmasq
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["dnsmasq", "--keep-in-foreground"]
