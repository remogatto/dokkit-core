#                                                                          
# File 'render.rb' created on 18 feb 2008 at 17:47:44.                    
#
# See 'dokkit.rb' or +LICENSE+ for license information.                      
#                                                                          
# (C) 2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

require 'dokkit/tasklib/base'

module Dokkit
  module TaskLib
    
    # Render task library defines a set of rake tasks devoted to the
    # transformation (rendering) of the documents and data files.
    class Render < Base
      
      attr_accessor :document_fns, :data_fns, :resource_factory, :logger
      
      # Initialize a set of tasks that transform resources.
      # +namespace+:: is the namespace for the tasks defined in the library.
      # +logger+:: is the logger instance.
      # +factory+:: is a factory class that creates document instances. 
      # +document_fns+:: is an array of source filenames.  
      # +data_fns+:: is an array of data files.       
      def initialize(ns = 'render')
        super
        
        yield self if block_given?

        @document_fns ||= []
        @data_fns ||= []

        define_tasks

      end
      
      # Use factory to get an instance of Dokkit::Resource::Document
      # starting from document filename.
      def get_document(document_fn)
        @resource_factory.get(:document, document_fn)  
      end
      
      # use factory to get an instance of Dokkit::Resource::Data
      # starting from data filename. Note that Data instances are
      # *immutable* resources, that is no rendering process occurs:
      # the file is copied as is.
      def get_data(data_fn)
        @resource_factory.get(:data, data_fn)
      end

      private
      
      # Create output directory +dn+ unless it already exists.
      def mkdir(dn)
        mkdir_p(dn, :verbose => false) unless File.exists?(dn)
      end
      
      # Write the result of the rendering to the target file. The
      # output directory is created at this time.
      def write_document(render_text, target_fn)
        mkdir(File.dirname(target_fn))
        File.open(target_fn, 'w') { |file| file << render_text }
      end
      
      # Copy the given source data file to the given target destination.
      def write_data(data)
        mkdir(File.dirname(data.target_fn))
        cp(data.source_fn, data.target_fn, :preserve => true, :verbose => false)
      end

      # Define render all documents task.
      def define_render_all_documents_task
        desc "Render documents."
        task :doc do
          render_all_documents
        end
      end
      
      def render_all_documents
        @document_fns.each { |fn| render_all_targets(get_document(fn)) }  
      end
      
      def render_all_targets(document)
        document.targets.each_key do |format|
          render_target(document, format) if (need_update?(document.target_for(format), document.deps_for(format)) and document.render?)
        end
      end
      
      def render_target(document, format)
        @logger.info("Render '#{document.source_fn}' => '#{document.target_for(format)}'.")
        write_document(document.render(:format => format), document.target_for(format))
      end
      
      # Define data task.
      def define_data_task
        desc "Copy data files."
        task :data do
          copy_all_data
        end
      end
      
      def copy_all_data
        @data_fns.each { |fn| copy_data(get_data(fn)) }
      end
      
      def copy_data(data)
        if need_update?(data.target_fn, data.source_fn)
          @logger.info("Copy '#{data.source_fn}' => '#{data.target_fn}'.")
          write_data(data)
        end
      end
      
      # Define a task that render all documents and copy all data.
      def define_render_all_task
        desc "Render the documents and copy the data."
        task :all => ["#{@ns}:doc", "#{@ns}:data"]
      end
      
      private
      
      # Compares target mtime against dependencies mtime. Returns true
      # if target mtime is greater than dependencies mtime returns
      # true. Otherwise return false (target needs update).
      def need_update?(target, deps)
        return true unless File.exists?(target)
        deps.each { |dep| return true if File.mtime(target) < File.mtime(dep) }
        false
      end
      
    end
  end
end
