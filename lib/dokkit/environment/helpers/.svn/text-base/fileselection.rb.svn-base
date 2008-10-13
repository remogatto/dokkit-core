#                                                                          
# File 'fileselection.rb' created on 01 mag 2008 at 16:31:18.                    
#
# See 'dokkit.rb' or +LICENSE+ for license information.                      
#                                                                          
# (C)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

require 'rake'

module Dokkit
  module Environment
    module Helper
      
      # FileSelection encapsulates the behaviour of Rake::FileList
      # class. Objects of class FileSelection are capable to return
      # the list of file in a directory. Objects are initialized with
      # a base directory. File list can be refined with
      # FileSelection#include and FileSelection#exclude instance
      # methods.
      class FileSelection
        
        attr_reader :base_dir, :includes, :excludes
        alias :dir :base_dir
        
        # Initialize a FileSelection object.
        # base_dir :: the base dir for all inclusion/exclusion operations.
        def initialize(base_dir = '.')
          @base_dir = base_dir
          @includes = []
          @excludes = []
          yield self if block_given?
        end
        
        # Include files to the list.
        # patterns :: array of glob patterns
        def include(*patterns)
          @includes.clear
          patterns.each { |pattern| @includes << pattern }
          self
        end
        
        # Exclude files from the list.
        # patterns :: array of glob patterns
        def exclude(*patterns)
          @excludes.clear
          patterns.each { |pattern| @excludes << pattern }
          self
        end
        
        # Return an array containing the file list.
        def files
          if File.exists?(@base_dir)  
            FileList.new(@base_dir) do |fl|
              fl.exclude *@excludes.collect { |exclude| File.join(@base_dir, exclude) } unless @excludes.empty?
              fl.include *@includes.collect { |include| File.join(@base_dir, include) } unless @includes.empty?
            end.uniq.select { |fn| not File.directory?(fn) }
          end
        end
      
      end
    end
  end
end
