# create a systemd unit file and optionaly enable it

def whyrun_supported?
  true
end

action :add do
  Chef::Log.debug "Adding systemd unit file for #{new_resource.name}"

  execute 'systemctl-daemon-reload' do
    command '/bin/systemctl --system daemon-reload'
    action :nothing
  end

  service new_resource.name do
    action :nothing
    provider Chef::Provider::Service::Systemd
    supports :status => true, :restart => true, :reload => true
    action :nothing
  end

  template "#{node["systemd"]["servicedir"]}/#{new_resource.name}" do
    source "systemd.service.erb"
    owner "root"
    mode 00600
    variables(
      :execstop => new_resource.execstop,
      :execstart => new_resource.execstart,
      :execprestart => new_resource.execprestart,
      :execstoppost => new_resource.execstoppost,
      :execstartpost => new_resource.execstartpost,
      :environment => new_resource.environment,
      :user => new_resource.user,
      :description => new_resource.description,
      :timeoutstartsec => new_resource.timeoutstartsec,
      :xfleet => new_resource.xfleet,
      :execreload => new_resource.execreload,
    )
    if (new_resource.activate)
      notifies :run, 'execute[systemctl-daemon-reload]', :immediately
      notifies :enable, "service[#{new_resource.name}]", :immediately
      notifies :restart, "service[#{new_resource.name}]", :immediately
    end
  end
  new_resource.updated_by_last_action(false)
end

action :remove do
  if ::File.exists?("#{node["systemd"]["servicedir"]}/#{new_resource.name}")
    Chef::Log.debug "Removing #{new_resource.name} from #{node["systemd"]["servicedir"]}"

  execute 'systemctl-daemon-reload' do
    command '/bin/systemctl --system daemon-reload'
    action :nothing
  end

  if (new_resource.activate)
    service new_resource.name do
      action :nothing
      provider Chef::Provider::Service::Systemd
      supports :status => true, :restart => true, :reload => true
      action [:disable, :stop]
    end
  end

  file "#{node["systemd"]["servicedir"]}/#{new_resource.name}" do
    action :delete
    if (new_resource.activate)
      notifies :run, 'execute[systemctl-daemon-reload]', :immediately
    end
  end

    new_resource.updated_by_last_action(true)
  end
end
