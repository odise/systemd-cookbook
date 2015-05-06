
actions :add, :remove, :start, :restart, :stop, :enable, :disable
default_action :add if defined?(default_action)

attribute :name, :kind_of => String, :name_attribute => true

attribute :requires, :kind_of => String, :required => false
attribute :after, :kind_of => String, :required => false
attribute :before, :kind_of => String, :required => false
attribute :bindsto, :kind_of => String, :required => false
attribute :wants, :kind_of => String, :required => false
attribute :partof, :kind_of => String, :required => false

attribute :execstartpre, :kind_of => String, :required => false
attribute :execstartpost, :kind_of => String, :required => false
attribute :execstoppost, :kind_of => String, :required => false
attribute :environment, :kind_of => Hash, :required => false, :default => {}

attribute :user, :kind_of => String, :required => false
attribute :description, :kind_of => String, :required => false, :default => "Dummy description"
attribute :timeoutstartsec, :kind_of => String, :required => false, :default => "1800s"
attribute :execstart, :kind_of => String, :required => true
attribute :execstop, :kind_of => String, :required => false
attribute :execreload, :kind_of => String, :required => false
attribute :killmode, :kind_of => String, :required => false
attribute :restart, :kind_of => String, :required => false, :equal_to => ['no', 'on-success', 'on-failure', 'on-abnormal', 'on-watchdog', 'on-abort', 'always']

# activate the service
attribute :activate, :kind_of => [TrueClass, FalseClass], :required => false, :default => false
# define a path to were the unit file will be deployed
attribute :deploypath, :kind_of => String, :required => false
