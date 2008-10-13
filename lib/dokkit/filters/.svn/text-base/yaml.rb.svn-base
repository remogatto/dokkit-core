#                                                                          
# File 'yaml.rb' created on 18 ago 2008 at 14:56:12.                    
#
# See 'dokkit.rb' or +LICENSE+ for license information.                      
#                                                                          
# (C)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

require 'yaml'

module Dokkit
  module Filter
    class YAML
      
      def initialize(document)
        @document = document
      end
      
      def filter(text)
        @document.configuration.recursive_merge! ::YAML::load(text)
        nil
      end
      
    end
  end
end
