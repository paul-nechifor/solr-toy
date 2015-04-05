from contextlib import contextmanager
from fabric.api import task, env, sudo, hide, settings, local
import os

root = os.path.dirname(os.path.realpath(__file__))
service = 'solr'


@task(default=True)
def dev_deploy():
    local('vagrant up')
    env.host_string = '172.16.60.10'
    env.key_filename = '~/.vagrant.d/insecure_private_key'
    env.user = 'vagrant'

    with say('Stopping the service'):
        with settings(warn_only=True):
            sudo('/sbin/service %s stop' % service)

    with say('Copying the files'):
        sudo(
            'rsync -a --del /vagrant/solr-home/ /opt/solr/example/solr/',
            user=env.user,
        )

    with say('Starting the service'):
        sudo('/sbin/service %s start' % service)

    with say('Updating the packages'):
        local('sleep 5; %s/scripts/load_data.py' % root)


@contextmanager
def say(message):
    print message + '...'
    with hide('everything'):
        yield
