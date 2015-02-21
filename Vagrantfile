required_plugins = %w( vagrant-proxyconf vagrant-vbguest vagrant-cachier )
required_plugins.each do |plugin|
  system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

Vagrant.configure('2') do |config|
  config.vm.box = 'centos-6.6'
  config.ssh.insert_key = false
  config.proxy.http = ENV['http_proxy']
  config.proxy.https = ENV['https_proxy']
  config.cache.scope = :box
  config.vm.network 'private_network', ip: '172.16.60.10'
  config.vm.provision 'shell', path: 'provision/provision.sh'
end
