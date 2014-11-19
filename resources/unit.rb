
actions :add, :remove
default_action :add if defined?(default_action)

attribute :name, :kind_of => String, :name_attribute => true

attribute :requires, :kind_of => Array, :required => false, :default => []
attribute :after, :kind_of => Array, :required => false, :default => []
attribute :before, :kind_of => Array, :required => false, :default => []
attribute :bindsto, :kind_of => Array, :required => false, :default => []
attribute :wants, :kind_of => Array, :required => false, :default => []
attribute :partof, :kind_of => Array, :required => false, :default => []
attribute :execstartpre, :kind_of => Array, :required => false, :default => []
attribute :execstartpost, :kind_of => Array, :required => false, :default => []
attribute :execstoppost, :kind_of => Array, :required => false, :default => []
attribute :environment, :kind_of => Hash, :required => false, :default => {}
attribute :xfleet, :kind_of => Hash, :required => false, :default => {}

attribute :user, :kind_of => String, :required => false
attribute :description, :kind_of => String, :required => false, :default => "Dummy description"
attribute :timeoutstartsec, :kind_of => String, :required => false, :default => "1800s"
attribute :execstart, :kind_of => String, :required => true
attribute :execstop, :kind_of => String, :required => true
attribute :execreload, :kind_of => String, :required => false
attribute :killmode, :kind_of => String, :required => false

# activate the service
attribute :activate, :kind_of => [TrueClass, FalseClass], :required => false, :default => false
# define a path to were the unit file will be deployed
attribute :deploypath, :kind_of => String, :required => false
