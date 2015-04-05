#!/bin/bash -eux

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

name="solr"
user="vagrant"

packages=(
  java
  rsync
)

main() {
  install_packages
  get_solr
}

install_packages() {
  yum -y shell <<<"
    update
    install ${packages[@]}
    run
  "
}

get_solr() {
  [[ -d /var/run/$name ]] || mkdir -p /var/run/$name
  [[ -d /var/log/$name ]] || mkdir -p /var/log/$name
  chown $user:$user /var/run/$name /var/log/$name

  cd /opt
  if [[ ! -d /opt/solr ]]; then
    local solr=solr-4.9.1
    wget -q https://archive.apache.org/dist/lucene/solr/4.9.1/${solr}.tgz
    tar -xzf ${solr}.tgz
    rm ${solr}.tgz
    mv $solr solr
    chown $user:$user -R solr/example
  fi

  local scripts="$root/scripts"
  if [[ ! -d $scripts ]]; then
    scripts="/vagrant/scripts"
  fi

  cp "$scripts/service" /etc/init.d/$name
  chkconfig --add $name
  chkconfig $name on
  service $name start
}

main "$@"
