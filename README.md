systemd-cookbook
==========
Chef cookbook to create [Systemd service unit](http://www.freedesktop.org/software/systemd/man/systemd.service.html) files.

Requirements
------------

- Chef 11

Attributes
----------

|Key|Dfault|Description|
|---|------|-----------|
| ["systemd"]["servicedir"]["path"] | "/etc/systemd/system" | Directory to store the unit file in if `deploypath` is not provided in the resource. |
| ["systemd"]["servicedir"]["create"] | true | Create directory if not exists. |
| ["systemd"]["servicedir"]["owner"]  | "root" | Owner of the directory. |
| ["systemd"]["servicedir"]["group"] | "root" | Group of the directory. |
| ["systemd"]["servicedir"]["mode"] | "00600" | Permission of the directory. |

Usage
-----

Define the unit file as a ~systemd_unit` resource in your cookbook. Have a look at the [unit LWRP](https://github.com/odise/systemd-cookbook/blob/master/resources/unit.rb) for parameters implemented at the moment.

```
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
```
