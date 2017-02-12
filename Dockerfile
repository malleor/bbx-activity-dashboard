FROM grafana/grafana

COPY ./grafana.ini /etc/grafana/grafana.ini
COPY ./dashboards/* /var/lib/grafana/dashboards/
COPY ./plugins/* /var/lib/grafana/plugins/

COPY ./run2.sh /run2.sh

ENTRYPOINT ["/run2.sh"]
CMD [""]
