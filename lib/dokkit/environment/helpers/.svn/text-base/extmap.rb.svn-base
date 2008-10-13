#                                                                          
# File 'extmap.rb' created on 14 mag 2008 at 10:52:17.                    
#
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (C)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

require 'dokkit/environment/helpers/fileselection'

module Dokkit
  module Environment
    module Helper
      class ExtMap < FileSelection
        def initialize(base_dir)
          super(base_dir)
          @ext = { }
        end
        def map(&blk)
          files.each { |fn| @ext[fn] = blk }
          self
        end
        def [](resource)
          @ext[resource]
        end
      end
    end
  end
end
