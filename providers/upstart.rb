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
      path "#{new_resource.deploypath}/#{new_resource.name}.conf"
    else
      path "#{node["upstart"]["servicedir"]["path"]}/#{new_resource.name}.conf"
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
      :starton => combine(Marshal.load(Marshal.dump(new_resource.starton)), pre: " started ", connector: " or "),
      :stopon => combine(Marshal.load(Marshal.dump(new_resource.stopon)), pre: " stopping ", connector: " or "),
      :killmode => new_resource.killmode,
      :restart => new_resource.restart,
    )
    cookbook "systemd"
    action :create
  end
end

action :remove do
  if new_resource.deploypath
    path = "#{new_resource.deploypath}/#{new_resource.name}.conf"
  else
    path = "#{node["upstart"]["servicedir"]["path"]}/#{new_resource.name}.conf"
  end

  file path do
    action :delete
  end
end

action :start do
  service new_resource.name do
    action [ :enable, :start ]
    supports :status => true
    provider Chef::Provider::Service::Upstart
  end
end

action :restart do
  # this is implemented to be stop/start instead of restart due 
  # to the fact that only stoping the unit forces Upstart to 
  # reload the configuration
  service new_resource.name do
    action :restart
    supports :status => true
    restart_command "(/sbin/stop #{new_resource.name} || true) && /sbin/start #{new_resource.name}"
    provider Chef::Provider::Service::Upstart
  end
end

action :stop do
  service new_resource.name do
    action :stop
    supports :status => true
    provider Chef::Provider::Service::Upstart
  end
end
