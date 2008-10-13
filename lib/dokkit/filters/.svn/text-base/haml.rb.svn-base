#                                                                          
# File 'haml.rb' created on 04 ago 2008 at 17:05:24.                    
#
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (C)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

begin
  require 'haml'
rescue LoadError
  nil
end

module Dokkit
  module Filter

    class Haml

      def initialize(document)
        @document = document
      end

      def filter(text)
        ::Haml::Engine.new(text).to_html(@document.get_binding)
      end      

    end    


  end
end



