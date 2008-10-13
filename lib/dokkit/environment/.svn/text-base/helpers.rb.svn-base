#                                                                          
# File 'helpers.rb' created on 04 mag 2008 at 17:44:17.                    
#
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (C)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

require 'ostruct'
require 'dokkit/environment/helpers/fileselection'
require 'dokkit/environment/helpers/extmap'

module Dokkit
  module Environment
    # Collect helper class that simplify the setup of
    # documentation environment.
    module Helper

      def configure(&blk)
        
        yield ostruct = OpenStruct.new        
        
        register :configuration do
          OpenStruct.new(default_configuration.merge(ostruct.marshal_dump))
        end
        
      end
      
      def select_document(&blk)
        
        yield new_fs = document_fs
                
        register :document_fs do
          FileSelection.new(configuration.document_dir) do |fs|
            fs.include(*new_fs.includes)
            fs.exclude(*new_fs.excludes)
          end
        end
        
      end

      def select_data(&blk)

        yield new_fs = data_fs

        register :data_fs do
          FileSelection.new(configuration.data_dir) do |fs|
            fs.include(*new_fs.includes)
            fs.exclude(*new_fs.excludes)
          end    
        end
        
      end

      def extend_document(glob, extension)
        FileSelection.new(configuration.document_dir).include(glob).files.each do |document_fn|
          @extmap[document_fn] = extension
        end
      end

    end
  end
end
