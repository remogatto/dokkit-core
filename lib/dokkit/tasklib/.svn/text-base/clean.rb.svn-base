#                                                                          
# File 'clean.rb' created on 14 apr 2008 at 16:04:19.                    
#
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (C) 2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

require 'dokkit/tasklib/base'

module Dokkit
  module TaskLib
    # The Clean task library is a collection of rake tasks devoted to
    # the cleaning of the documentation environment. The library
    # defines a clean:output that remove the generated output folder
    # (if exists). It defines also a clean:cache task that remove the
    # cache folder (if exists).
    class Clean < Base
      
      attr_accessor :output_dir, :cache_dir
      
      # Initialize the library with the logger instance, an optional
      # namespace and configuration hash.
      def initialize(ns = 'clean')
        super
        
        yield self if block_given?

        define_tasks
      end
      
      private
      
      # Define a task to remove output directory.
      def define_output_task
        desc "Remove the generated output."
        task :output do
          remove_dir(output_dir)
        end
      end
      
      # Define a task to remove cache directory.
      def define_cache_task
        desc "Remove cache directory."
        task :cache do
          remove_dir(cache_dir)
        end
      end
      
      def remove_dir(dir)
        if File.exists?(dir)
          @logger.info("Removing directory '#{dir}'.")
          rm_rf dir unless dir == '.'
        end        
      end
       
      # Define a task that clean the documentation environment
      # removing both output and cache directory.
      def define_clean_all_task
        desc "Clean the documentation environment."
        task :all => ["#{@ns}:output", "#{@ns}:cache"]
      end
      
    end
  end
end
