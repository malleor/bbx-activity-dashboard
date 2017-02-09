FROM grafana/grafana

COPY ./grafana.ini /etc/grafana/grafana.ini
COPY ./run2.sh /run2.sh

ENTRYPOINT ["/run2.sh"]
CMD [""]
