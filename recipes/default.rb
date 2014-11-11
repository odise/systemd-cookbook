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
end

systemd_unit 'test.service' do
  action "remove"
end
