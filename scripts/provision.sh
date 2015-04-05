#!/bin/bash -eux

packages=(
  java
  tomcat6
  tomcat6-admin-webapps
  tomcat6-webapps
)

main() {
  install_packages
  setup_tomcat
  get_requirements
  get_solr
}

install_packages() {
  yum -y shell <<<"
    update
    install ${packages[@]}
    run
  "
}

setup_tomcat() {
  cat > /etc/tomcat6/tomcat-users.xml <<END
<?xml version='1.0' encoding='utf-8'?>
<tomcat-users>
  <role rolename='manager'/>
  <role rolename='admin'/>
  <user username='admin' password='admin' roles='manager,admin'/>
</tomcat-users>
END

  chkconfig tomcat6 on
  service tomcat6 start
}

get_requirements() {
  install_from_maven commons-logging 1.1.3

  cd
  wget -q http://www.slf4j.org/dist/slf4j-1.7.10.tar.gz
  tar -xzf slf4j-1.7.10.tar.gz
  rm slf4j-*/slf4j-*-sources.jar
  cp slf4j-*/slf4j-*.jar /usr/share/tomcat6/lib
  rm -fr slf4j-*
}

get_solr() {
  cd
  local solr=solr-4.9.1
  wget -q https://archive.apache.org/dist/lucene/solr/4.9.1/${solr}.tgz
  tar -xzf ${solr}.tgz
  cp ~/$solr/dist/${solr}.war /usr/share/tomcat6/webapps/solr.war


  mkdir /opt/solr-dir
  cp -r $solr/example/solr/* /opt/solr-dir
  chown -R tomcat /opt/solr-dir

  service tomcat6 restart
  sleep 20

  local replacement='<env-entry><env-entry-name>solr\/home<\/env-entry-name><env-entry-value>\/opt\/solr-dir<\/env-entry-value><env-entry-type>java.lang.String<\/env-entry-type><\/env-entry>'
  perl -i -0pe "s/\\n<\\/web-app>/$replacement<\\/web-app>/" /usr/share/tomcat6/webapps/solr/WEB-INF/web.xml

  rm -fr ~/solr-*

  service tomcat6 restart
}

install_from_maven() {
  cd /usr/share/tomcat6/lib
  wget -q "http://central.maven.org/maven2/$1/$1/$2/$1-${2}.jar"
}

main "$@"
