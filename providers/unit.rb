# create a systemd unit file and optionaly enable it

def whyrun_supported?
  true
end

use_inline_resources

action :add do
  Chef::Log.debug "Adding systemd unit file for #{new_resource.name}"

  directory node["systemd"]["servicedir"]["path"] do
    owner node["systemd"]["servicedir"]["owner"]
    group node["systemd"]["servicedir"]["group"]
    recursive true
  end if node["systemd"]["servicedir"]["create"]

  template new_resource.name do
    if new_resource.deploypath
      path "#{new_resource.deploypath}/#{new_resource.name}"
    else
      path "#{node["systemd"]["servicedir"]["path"]}/#{new_resource.name}"
    end
    source "systemd.service.erb"
    owner node["systemd"]["servicedir"]["owner"]
    group node["systemd"]["servicedir"]["group"]
    mode node["systemd"]["servicedir"]["mode"]
    variables(
      :execstop => new_resource.execstop,
      :execstart => new_resource.execstart,
      :execstartpre => new_resource.execstartpre,
      :execstoppost => new_resource.execstoppost,
      :execstartpost => new_resource.execstartpost,
      :environment => new_resource.environment,
      :user => new_resource.user,
      :description => new_resource.description,
      :timeoutstartsec => new_resource.timeoutstartsec,
      :xfleet => new_resource.xfleet,
      :execreload => new_resource.execreload,
      :requires => new_resource.requires,
      :before => new_resource.before,
      :after => new_resource.after,
      :bindsto => new_resource.bindsto,
      :wants => new_resource.wants,
      :partof=> new_resource.partof,
      :killmode => new_resource.killmode,
      :restart => new_resource.restart,
    )
    cookbook "systemd"
    action :create
  end
end

action :remove do
end
