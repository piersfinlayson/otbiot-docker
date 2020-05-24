FROM piersfinlayson/build-amd64:0.3.1

LABEL maintainer="Piers Finlayson <piers@piersandkatie.com>"

LABEL description="Piers's openapi-generator Container"

USER build

RUN cd ~ && \
    git clone https://github.com/OpenAPITools/openapi-generator && \
    cd ./openapi-generator && \
    mvn clean install && \
    cd ~

CMD ["/bin/bash"]
