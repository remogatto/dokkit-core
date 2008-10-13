#                                                                          
# File 'basic.rb' created on 01 mag 2008 at 15:37:33.                    
#
# See 'dokkit.rb' or +LICENSE+ for license information.                      
#                                                                          
# (C)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

require 'ostruct'
require 'dokkit'
require 'dokkit/environment'
require 'dokkit/environment/helpers'
require 'dokkit/logging'
require 'dokkit/factory'
require 'dokkit/resource'
require 'dokkit/tasklib'
require 'dokkit/filters'
require 'dokkit/cache'

module Dokkit
  module Environment

    def environment(&blk) Basic.new(&blk); end
    
    class Basic < Container

      include Dokkit::Environment::Helper
      
      def initialize(&blk)
        super
        add_lib_to_load_path
        
        init_extmap
        init_services
        
        yield self if block_given?        
        
        define_tasks
      end
      
      def define_tasks
        render
        clean
      end
      
      def init_services
        methods.select { |meth| meth =~ /register_/ }.each { |meth| send(meth) }
      end
      
      def register_document_fs
        register :document_fs do
          Environment::Helper::FileSelection.new(configuration.document_dir) do |fs|
            fs.include('**/*')
            fs.exclude('**/*.yaml')
          end
        end
      end
      
      def register_data_fs
        register :data_fs do
          Environment::Helper::FileSelection.new(configuration.data_dir) do |fs|
            fs.include('**/*')
          end
        end
      end
      
      def register_extmap
        register :extmap do
          Helper::ExtMap.new(configuration.document_dir)
        end
      end
      
      def register_filter_factory
        register :filter_factory do
          Dokkit::Factory.new do |factory|
            factory.add('nil') { Dokkit::Filter::Nil.new } 
            factory.add('erb') { |document| Dokkit::Filter::ERB.new(document) }
            factory.add('yaml') { |document| Dokkit::Filter::YAML.new(document) }
            factory.add('tidy') { Dokkit::Filter::Tidy.new }
            factory.add('maruku-html') { Dokkit::Filter::MarukuHTML.new }
            factory.add('deplate-latex') { Dokkit::Filter::DeplateLatex.new }
            factory.add('deplate-html') { Dokkit::Filter::DeplateHTML.new }
            factory.add('deplate-text') { Dokkit::Filter::DeplateText.new }
            factory.add('haml') { |document| Dokkit::Filter::Haml.new(document) }
          end
          
        end
      end
      
      def register_resource_factory
        register :resource_factory do
          Factory.new do |factory|
            factory.add(:document, &document_factory_block)
            factory.add(:data, &data_factory_block)
          end        
        end
      end
      
      def register_cache
        register :cache do
          Cache.new
        end
      end
      
      def register_render
        register :render do
          TaskLib::Render.new do |task|
            task.logger = logger
            task.resource_factory = resource_factory
            task.document_fns = document_fs.files
            task.data_fns = data_fs.files
          end
        end
      end
      
      def register_clean
        register :clean do
          TaskLib::Clean.new do |task|
            task.logger = logger
            task.output_dir = configuration.output_dir
            task.cache_dir = configuration.cache_dir
          end
        end
      end
      
      def register_logger
        register :logger do
          Logging::Observer::Console.logger          
        end
      end
      
      def register_configuration
        register :configuration do
          OpenStruct.new(default_configuration)
        end
      end
      
      # Add lib folder to the load path.
      def add_lib_to_load_path
        $: << 'lib'
      end

      def init_extmap
        @extmap = { }
      end
      
      def default_filter_chain
        { 
          'deplate' => { 'html' => ['erb', 'deplate-html'], 'latex' => ['erb', 'deplate-latex'], 'text' => ['erb', 'deplate-text']},
          'maruku' => { 'html' => ['erb', 'maruku-html'], 'latex' => ['erb', 'maruku-latex'] },
          'haml' => { 'html' => ['haml'] },
        }  
      end
      
      def default_postfilter_chain
        { 'deplate' => {'html' => ['erb'], 'latex' => ['erb'], 'text' => ['erb'] },
          'maruku' => {'html' => ['erb'], 'latex' => ['erb'], 'text' => ['erb'] },
          'haml' => {'html' => ['haml'] }
        }  
      end

      def default_configuration
        {
          :document_dir => 'doc/pages',
          :config_dir => 'doc/configs',
          :layout_dir => 'doc/layouts',
          :data_dir => 'doc/data',
          :output_dir => 'output',
          :cache_dir => '.cache',
          :default_filter_chain => default_filter_chain,
          :default_postfilter_chain => default_postfilter_chain 
        }                    
      end

      def document
        register :document do
          Resource::Document.new(source_fn, configuration.marshal_dump) do |document|
            document.logger = logger
            document.cache = cache
            document.resource_factory = resource_factory
            document.filter_factory = filter_factory
          end          
        end
      end
      
      # Return a block that is able to construct a Document instance.
      def document_factory_block
        lambda do |source_fn|
          Resource::Document.new(source_fn, configuration.marshal_dump) do |document|
            document.logger = logger
            document.cache = cache
            document.resource_factory = resource_factory
            document.filter_factory = filter_factory
            document.extend @extmap[source_fn] if @extmap[source_fn]
          end
        end
      end
      
      def data_factory_block
        lambda do |source_fn|
          Resource::Data.new(source_fn, configuration.marshal_dump)
        end
      end

    end
    
  end
end
