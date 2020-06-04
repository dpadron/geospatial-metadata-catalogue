FROM tomcat:8.5.51-jdk8-openjdk-slim
LABEL maintainer="Patrice MAUNY (patrice.mauny@gmail.com)"

ENV GN_FILE geonetwork.war
# Default, applied only if not defined in docker-compose.yml file
ENV DATA_DIR=$CATALINA_HOME/webapps/geonetwork/WEB-INF/data
ENV JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -server -Xms512m -Xmx2024m -XX:NewSize=512m -XX:MaxNewSize=1024m -XX:+UseConcMarkSweepGC"

#Environment variables
ENV GN_VERSION 3.10.2
ENV GN_DOWNLOAD_MD5 86b18cd2ef60f11dd1dbe055054cee97
ENV INSTALL_DIR /usr/local/geonetwork
ENV DATA_DIR /var/lib/geonetwork_data

WORKDIR $CATALINA_HOME/webapps

RUN apt-get update && apt-get install -y --no-install-recommends \
       curl \
       unzip

RUN curl -fSL -o $GN_FILE \
     #https://sourceforge.net/projects/geonetwork/files/GeoNetwork_opensource/v${GN_VERSION}/geonetwork.war/download && \
     #echo "$GN_DOWNLOAD_MD5 *$GN_FILE" | md5sum -c && \
     #mkdir -p geonetwork && \
     # -> Backup solution
     http://nightlybuild.geonetwork-opensource.org/3.10.x/geonetwork-3.10.3-SNAPSHOT-2020-06-04.war && \
     mkdir -p $INSTALL_DIR && \
     unzip -e $GN_FILE -d $INSTALL_DIR && \
     rm $GN_FILE

#Copy context file
COPY conf/ROOT.xml $CATALINA_HOME/conf/Catalina/localhost/ROOT.xml

#Set geonetwork data dir
COPY conf/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["catalina.sh", "run"]
