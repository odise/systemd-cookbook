#
# Cookbook systemd.
# Recipe:: default
#
# Copyright 2014, kreuzwerker GmbH
#
# All rights reserved - Do Not Redistribute
#

systemd_unit 'test.service' do
  execstart "/bin/true"
  execstop "/bin/false"
  deploypath "/tmp"
end

systemd_unit 'test2.service' do
  execstart "/bin/true"
  execstop "/bin/false"
end

systemd_unit 'test2.service' do
  action "remove"
end
