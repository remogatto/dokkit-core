#                                                                          
# File 'data.rb' created on 21 apr 2008 at 14:28:57.                    
#
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (C) 2006, 2007, 2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

require 'dokkit/resource/filenamehelper'

module Dokkit
  module Resource
    # Data are *immutable* resources. Data files are copied from
    # source directory (usually doc/data) to output directory. No
    # rendering process occurs during copying.
    class Data
      include FilenameHelper
      attr_reader :source_fn, :configuration
      # A Data instance is initialized with the source filename and a
      # configuration hash containing data and output directory.
      def initialize(source_fn, configuration = { :data_dir => 'doc/data', :output_dir => 'output' } )
        @source_fn = source_fn
        @configuration = configuration
      end
      # Return the filename of the target data file.
      #
      # Example:
      #
      # target_fn = Data.new('doc/data/data_1').target_fn #=> 'output/data_1'
      #
      def target_fn
        filename_helper(source_fn, @configuration[:data_dir], @configuration[:output_dir], '')        
      end
    end
  end
end
