#                                                                          
# File 'tidy.rb' created on 27 lug 2008 at 12:02:48.                    
#
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (C)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

require 'maruku'

module Dokkit
  module Filter
    
    class Tidy
      
      def filter(text)
        cmd = "tidy -q -i"
        out = IO.popen(cmd, 'r+') do |tidy|
          tidy.write text
          tidy.close_write
          tidy.read
        end
      end
      
    end
    
  end
end

