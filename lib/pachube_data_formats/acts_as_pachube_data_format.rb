module ActsAsPachubeDataFormat
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def acts_as_pachube_data_format(klass, options = {})
      send :include, InstanceMethods
    end
  end

  module InstanceMethods
    # Instance Methods we wish to add to activerecord should go here
  end
end

