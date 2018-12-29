FROM piersfinlayson/esp8266-build:3.0.0

LABEL maintainer="Piers Finlayson <piers@piersandkatie.com>"

LABEL description="otbiot Pre-built Image Container"

USER esp
RUN cd /home/esp/ && \
    git clone --recursive https://github.com/piersfinlayson/otb-iot && \
    cd otb-iot/ && \
    make all docs

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]
