default['systemd']['update'] = false
default["systemd"]["servicedir"]["path"] = "/etc/systemd/system"
default["systemd"]["servicedir"]["create"] = true
default["systemd"]["servicedir"]["owner"] = "root"
default["systemd"]["servicedir"]["group"] = "root"
default["systemd"]["servicedir"]["mode"] = "00644"

default["upstart"]["servicedir"]["path"] = "/etc/init"
default["upstart"]["servicedir"]["create"] = true
default["upstart"]["servicedir"]["owner"] = "root"
default["upstart"]["servicedir"]["group"] = "root"
default["upstart"]["servicedir"]["mode"] = "00644"
