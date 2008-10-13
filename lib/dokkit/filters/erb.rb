#                                                                          
# File 'erb.rb' created on 23 lug 2008 at 15:40:59.                    
#
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (C)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

require 'erb'

module Dokkit
  module Filter

    class ERB
      
      def initialize(document)
        @document = document
      end
      
      def filter(text)
        ::ERB.new(text).result(@document.get_binding)
      end
      
    end

  end
end
