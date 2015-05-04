def whyrun_supported?
  true
end

use_inline_resources

action :add do
  Chef::Log.debug "Adding Upstart config file for #{new_resource.name}"

  directory node["upstart"]["servicedir"]["path"] do
    owner node["upstart"]["servicedir"]["owner"]
    group node["upstart"]["servicedir"]["group"]
    recursive true
  end if node["upstart"]["servicedir"]["create"]

  template new_resource.name do
    if new_resource.deploypath
      path "#{new_resource.deploypath}/#{new_resource.name}"
    else
      path "#{node["upstart"]["servicedir"]["path"]}/#{new_resource.name}"
    end
    source "upstart.conf.erb"
    owner node["upstart"]["servicedir"]["owner"]
    group node["upstart"]["servicedir"]["group"]
    mode node["upstart"]["servicedir"]["mode"]
    variables(
      #pre-stop
      :execstop => new_resource.execstop,
      # script
      :execstart => new_resource.execstart,
      # pre-start
      :execstartpre => new_resource.execstartpre,
      # post-stop
      :execstoppost => new_resource.execstoppost,
      # post-start
      :execstartpost => new_resource.execstartpost,
      # env/export dict
      :environment => new_resource.environment,
      # setuid
      :user => new_resource.user,
      # description
      :description => new_resource.description,
      # not supported
      :timeoutstartsec => new_resource.timeoutstartsec,
      # reload: XXX remove
      :execreload => new_resource.execreload,
      :starton => new_resource.starton,
      :stopon => new_resource.stopon,
      :killmode => new_resource.killmode,
      :restart => new_resource.restart,
    )
    cookbook "systemd"
    action :create
  end
end

action :remove do
end
