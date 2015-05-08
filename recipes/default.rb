#
# Cookbook systemd.
# Recipe:: default
#
# Copyright 2014, kreuzwerker GmbH
#
# All rights reserved - Do Not Redistribute
#

case node['platform']

  # CENTOS 7
  when 'amazon', 'centos', 'fedora', 'redhat'
    execute 'systemctl-daemon-reload' do
      command '/bin/systemctl --system daemon-reload'
      action :nothing
    end

    systemd_unit 'container-test.service' do
      after ['docker.service']
      requires ['docker.service']
      execstartpre <<-EOF
        -/usr/bin/docker rm -f test
      EOF
      execstart <<-EOF
        /usr/bin/docker run --name test --rm \
          odise/busybox-curl \
          /bin/sh -c 'while true; do echo xxx; sleep 2; done'
      EOF
      execstop <<-EOF
        -/usr/bin/docker kill test
      EOF
      restart 'always'
      timeoutstartsec '0'
      notifies :run, 'execute[systemctl-daemon-reload]', :delayed
    end

    systemd_unit 'container-dependency.service' do
      after ['container-test.service']
      requires ['container-test.service']
      execstartpre <<-EOF
        /usr/bin/docker rm -f dependency || true
      EOF
      execstart <<-EOF
        /usr/bin/docker run --name dependency --rm \
          --link test:test odise/busybox-curl \
          /bin/sh -c 'while true; do echo zzzz; sleep 2; done'
      EOF
      execstop  <<-EOF
        -/usr/bin/docker kill dependency
      EOF
      restart 'always'
      timeoutstartsec '0'
      notifies :run, 'execute[systemctl-daemon-reload]', :delayed
    end

    execute 'systemctl start container' do
      command '/bin/systemctl start container-dependency'
      action :run
    end

  # UBUNTU 14.04
  when 'debian', 'ubuntu'

    systemd_upstart 'container-test.conf' do
      starton ["docker"]
      stopon ["docker"]
      execstartpre <<-EOF
        /usr/bin/docker rm -f test || true
      EOF
      execstart <<-EOF
        /usr/bin/docker run --name test --rm \
          odise/busybox-curl \
          /bin/sh -c 'while true; do echo xxx; sleep 2; done'
      EOF
      execstop <<-EOF
        /usr/bin/docker kill test
      EOF
      restart 'always'
      execstoppost "exec sleep 5"
    end

    systemd_upstart 'container-dependency.conf' do
      starton ["container-test "]
      stopon ["container-test"]
      execstartpre <<-EOF
        /usr/bin/docker rm -f dependency || true
      EOF
      execstart <<-EOF
        /usr/bin/docker run --name dependency --rm \
          --link test:test odise/busybox-curl \
          /bin/sh -c 'while true; do echo zzzz; sleep 2; done'
      EOF
      execstop  <<-EOF
        /usr/bin/docker kill dependency || true
      EOF
      restart 'always'
      execstoppost "exec sleep 5"
    end

    systemd_upstart 'logspout.conf' do
      starton ["docker"]
      stopon ["docker"]
      execstartpre <<-EOF
        /usr/bin/docker rm -f logspout || true
      EOF
      execstart <<-EOF
        /usr/bin/docker run --name logspout --rm \
          --volume=/var/run/docker.sock:/tmp/docker.sock \
          --publish=8000:8000 \
          gliderlabs/logspout
      EOF
      execstop  <<-EOF
        /usr/bin/docker kill logspout || true
      EOF
      execstoppost "exec sleep 5"
      restart 'always'
    end
end
