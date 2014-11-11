
actions :add, :remove
default_action :add if defined?(default_action)

attribute :name, :kind_of => String, :name_attribute => true

attribute :execprestart, :kind_of => Hash, :required => false, :default => {}
attribute :execstartpost, :kind_of => Hash, :required => false, :default => {}
attribute :execstoppost, :kind_of => Hash, :required => false, :default => {}
attribute :environment, :kind_of => Hash, :required => false, :default => {}
attribute :xfleet, :kind_of => Hash, :required => false, :default => {}

attribute :user, :kind_of => String, :required => false
attribute :description, :kind_of => String, :required => false, :default => "Dummy description"
attribute :timeoutstartsec, :kind_of => String, :required => false
attribute :execstart, :kind_of => String, :required => true
attribute :execstop, :kind_of => String, :required => true
attribute :execreload, :kind_of => String, :required => false

attribute :activate, :kind_of => [TrueClass, FalseClass], :required => false, :default => false
