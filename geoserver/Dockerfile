FROM tomcat:9-jdk11
LABEL maintainer="Elastic Labs <contact@elasticlabs.co>"

ENV \
    # Geoserver installation basics
    GEOSERVER_VERSION=2.18.0 \
    GEOSERVER_DATA_DIR=/var/local/geoserver \
    GEOSERVER_ADMIN_USER=admin \
    GEOSERVER_ADMIN_PASSWORD=myawesomegeoserver \
    # https://docs.geoserver.org/stable/en/user/production/container.html#optimize-your-jvm
    INITIAL_MEMORY=1G \
    MAXIMUM_MEMORY=2G

# Geoserver WAR location 
ENV WAR_URL=http://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip 

#
# Build (1/ ) Add Microsoft + some other fonts for SLD labels rendering
RUN echo "deb http://httpredir.debian.org/debian stretch contrib" >> /etc/apt/sources.list
RUN set -x \
	&& apt-get -y update \
	&& apt-get install -y ttf-mscorefonts-installer fonts-cantarell lmodern ttf-aenigma ttf-georgewilliams ttf-bitstream-vera ttf-sjfonts tv-fonts \
        build-essential libapr1-dev libssl-dev default-jdk libnetcdf-dev \
    && apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

#
# Build (2/ ) Download & deploy GeoServer
RUN mkdir ${GEOSERVER_DATA_DIR} \
    && mkdir /tmp/resources \
    # Get and deploy Geoserver version
	&& wget -c --no-check-certificate ${WAR_URL} -O /tmp/resources/geoserver-${GEOSERVER_VERSION}.zip \
	&& unzip /tmp/resources/geoserver-${GEOSERVER_VERSION}.zip -d /tmp/geoserver \
	&& unzip /tmp/geoserver/geoserver.war -d ${CATALINA_HOME}/webapps/geoserver \
    # Move necessary files outside default deployment directory
    && cp -r ${CATALINA_HOME}/webapps/geoserver/data/user_projections ${GEOSERVER_DATA_DIR} \
    && cp -r ${CATALINA_HOME}/webapps/geoserver/data/security ${CATALINA_HOME} \
    && rm -rf ${CATALINA_HOME}/webapps/geoserver/data \
    && rm -rf /tmp/geoserver \
    # Remove Tomcat manager, docs, and examples
    && rm -rf ${CATALINA_HOME}/webapps/ROOT \
    && rm -rf ${CATALINA_HOME}/webapps/docs \
    && rm -rf ${CATALINA_HOME}/webapps/examples \
    && rm -rf ${CATALINA_HOME}/webapps/host-manager \
    && rm -rf ${CATALINA_HOME}/webapps/manager; 

#
# Build (3/ ) Enable CORS
RUN sed -i '\:</web-app>:i\
<filter>\n\
    <filter-name>CorsFilter</filter-name>\n\
    <filter-class>org.apache.catalina.filters.CorsFilter</filter-class>\n\
    <init-param>\n\
        <param-name>cors.allowed.origins</param-name>\n\
        <param-value>*</param-value>\n\
    </init-param>\n\
    <init-param>\n\
        <param-name>cors.allowed.methods</param-name>\n\
        <param-value>GET,POST,HEAD,OPTIONS,PUT</param-value>\n\
    </init-param>\n\
</filter>\n\
<filter-mapping>\n\
    <filter-name>CorsFilter</filter-name>\n\
    <url-pattern>/*</url-pattern>\n\
</filter-mapping>' ${CATALINA_HOME}/webapps/geoserver/WEB-INF/web.xml

#
# Build (4/ ) Tomcat environment
# CSRF disabled to enable proper AJAX work (https://docs.geoserver.org/stable/en/user/security/webadmin/csrf.html)
ENV CATALINA_OPTS "-server -Djava.awt.headless=true \
	-Xms${INITIAL_MEMORY} -Xmx${MAXIMUM_MEMORY} -XX:+UseConcMarkSweepGC -XX:NewSize=48m \
	-DGEOSERVER_DATA_DIR=${GEOSERVER_DATA_DIR} -DGEOSERVER_CSRF_DISABLED=true"

# Create tomcat user to avoid root access. 
RUN addgroup --gid 1099 tomcat && useradd -m -u 1099 -g tomcat tomcat \
    && chown -R tomcat:tomcat . \
    && chown -R tomcat:tomcat ${GEOSERVER_DATA_DIR} \
    && chown -R tomcat:tomcat ${CATALINA_HOME}/webapps/geoserver/

ADD conf/entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "/bin/sh", "/usr/local/bin/entrypoint.sh"]