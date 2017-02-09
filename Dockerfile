FROM grafana/grafana

COPY ./grafana.ini /etc/grafana/grafana.ini

ENTRYPOINT ["/run.sh"]
CMD []
