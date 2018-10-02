FROM maven:3
LABEL maintainer="Tomaer Ma<i@tomaer.com>"

WORKDIR /opt/b3log/solo
ADD . /tmp

RUN cd /tmp && mvn install -Pci && mv target/solo/* /opt/b3log/solo/ \
    && mkdir -p /opt/b3log/backup/ && mkdir -p /opt/b3log/tmp/ && mkdir -p /opt/b3log/solo/assets/ \
    && rm -rf /opt/b3log/solo/WEB-INF/classes/local.properties /opt/b3log/solo/WEB-INF/classes/mail.properties /opt/b3log/solo/WEB-INF/classes/latke.properties \
    && rm -rf /tmp/* && rm -rf ~/.m2

ADD ./src/main/resources/docker/entrypoint.sh $WORKDIR
ADD ./src/main/resources/docker/local.properties.h2 /opt/b3log/tmp
ADD ./src/main/resources/docker/local.properties.mysql /opt/b3log/tmp
ADD ./src/main/resources/docker/mail.properties /opt/b3log/tmp
ADD ./src/main/resources/docker/latke.properties /opt/b3log/tmp

ADD ./blog/skins/* /opt/b3log/solo/skins/

RUN chmod 777 /opt/b3log/solo/entrypoint.sh

VOLUME ["/opt/b3log/backup/", "/opt/b3log/solo/skins/", "/opt/b3log/solo/markdowns/", "/opt/b3log/solo/assets/"]

EXPOSE 8080

ENTRYPOINT [ "/opt/b3log/solo/entrypoint.sh" ]
