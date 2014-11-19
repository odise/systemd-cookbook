#
# Cookbook systemd.
# Recipe:: default
#
# Copyright 2014, kreuzwerker GmbH
#
# All rights reserved - Do Not Redistribute
#

execute 'systemctl-daemon-reload' do
  command '/bin/systemctl --system daemon-reload'
  action :nothing
end

systemd_unit 'test.service' do
  execstart "/bin/true"
  execstop "/bin/true"
  deploypath "/tmp"
  notifies :run, 'execute[systemctl-daemon-reload]', :immediately
end

#systemd_unit 'test2.service' do
#  execstart "/bin/true"
#  execstop "/bin/false"
#end

#systemd_unit 'test2.service' do
#  action "remove"
#end
