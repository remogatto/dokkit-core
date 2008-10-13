
# File 'factory.rb' created on 25 apr 2008 at 19:43:56.                    
#
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (C)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

module Dokkit
  class Factory

    # Return stored instances.
    attr_reader :instances

    # Return stored factory method.
    attr_reader :methods

    # Initialize a Factory object. Configuration is made passing a
    # code block.
    def initialize
      @instances, @methods = { }, { }
      yield self if block_given?
    end

    # Add a factory method associated with the given class of objects.
    # +factory_method+ is a class/method pair.
    #
    # Example:
    # 
    # factory.add(:bar) { Bar.new } # add a method that
    #                               # instantiates Bar object
    #
    def add(key, &factory_method)
      @methods[key] = factory_method
    end

    # Construct an instance for the given class. Note that, if an
    # instance of the same class has been already instantiated for a
    # given parameters set, then *no* new instance will be created but
    # the first one will be returned.
    def get(key, *params)
      get_instance(key, *params) || store_instance(key, *params)
    end
    
    private
    
    def store_instance(key, *params)
      @instances[ [key].concat(params) ] = @methods[key].call(*params)
    end

    def get_instance(key, *params)
      @instances[ [key].concat(params) ]
    end    

  end
end
