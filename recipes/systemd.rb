case node['platform']
  when 'centos'
    if node['platform_version'].to_f > 6.9

      if node['systemd']['update']

        # curl --silent -H'Accept: text/plain' \
        #  'http://localhost:19531/entries?follow&_SYSTEMD_UNIT=container-test.service&_SYSTEMD_UNIT=docker.service'
        remote_file "/etc/yum.repos.d/lnykryn-systemd-epel-7.repo" do
          source "https://copr.fedoraproject.org/coprs/lnykryn/systemd/repo/epel-7/lnykryn-systemd-epel-7.repo"
        end

        execute "yum update" do
          command "yum update -y"
        end
      end

      package 'systemd-journal-gateway'

      execute "enable and start systemd-journal-gatewayd" do
        command "systemctl enable systemd-journal-gatewayd.socket && systemctl start systemd-journal-gatewayd.socket"
      end

    else
      fail "Systemd package for Centos `#{node['platform_version']} is not supported.`"
    end

  else
    fail "Systemd package for `#{node['platform']} is not supported.`"

end
