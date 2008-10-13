#                                                                          
# File 'maruku.rb' created on 15 feb 2008 at 22:58:04.                    
#
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (C) 2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

require 'maruku'

module Dokkit
  module Filter
    
    class MarukuHTML
      
      def filter(text)
        Maruku.new(text).to_html
      end
      
    end

    class MarukuLatex
      
      def filter(text)
        Maruku.new(text).to_latex
      end
      
    end

  end
end

