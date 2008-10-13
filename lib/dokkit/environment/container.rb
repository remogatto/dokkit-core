#                                                                          
# File 'container.rb' created on 15 ago 2008 at 15:16:11.                    
#
# See 'dokkit.rb' or +LICENSE+ for license information.                      
#                                                                          
# (C)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

module Dokkit
  module Environment

    class Container
      
      def initialize
        @registry = { }
        @instances = { }
      end
      
      def method_missing(meth)
        self[meth]
      end
      
      def [](service_name)
        @instances[service_name] || (@instances[service_name] = @registry[service_name].call)
      end
      
      def register(service_name, &blk)
        @instances[service_name] = nil
        @registry[service_name] = blk
      end
            
    end

  end
end
