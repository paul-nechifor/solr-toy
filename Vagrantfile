Vagrant.configure('2') do |config|
  config.vm.box = 'centos-6.6-solr-toy'
  config.ssh.insert_key = false
  config.vm.network 'private_network', ip: '172.16.60.10'
  config.vm.provision 'shell', path: 'scripts/provision.sh'
end
