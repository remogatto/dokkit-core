#
# File 'document.rb' created on 17 apr 2008 at 18:04:42.
#
# See 'dokkit.rb' or +LICENSE+ for licence information.
#
# (C) 2006, 2007, 2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors).
#

require 'rubygems'

require 'yaml'
require 'erb'
require 'dokkit/hash'
require 'dokkit/resource/extensions/builtin'
require 'dokkit/resource/filenamehelper'

module Dokkit
  module Resource
    # Document is the core resource class of dokkit. Document
    # instances are usually created on demand by
    # Dokkit::Resource::Factory.
    class Document
      include FilenameHelper, Extension::Builtin

      attr_accessor :logger, :cache, :resource_factory, :filter_factory
      
      attr_reader :source_fn, :env_configuration, :configuration
      attr_reader :configs, :targets, :layouts, :deps
      attr_reader :formatter, :format
      
      # Initialize a Document instance.
      # +source_fn+:: is the file name of the document source file.
      # +configuration+:: is the configuration hash to be associated with the document.
      # +logger+:: is the logger instance.
      # +cache+:: is the cache manager instance.
      def initialize(source_fn, env_configuration, &blk)
        @source_fn = source_fn
        @env_configuration = env_configuration

        reconfigure(&blk)
      end
      
      def config(config_fn)
        reconfigure('config' => config_fn)
      end
      
      def layout(layout_fn)
        reconfigure('layout' => layout_fn)  
      end
      
      def reconfigure(configuration = { }, &blk)
        init_default(configuration)

        yield self if block_given?
        
        configure
      end
      
      def get_binding
        binding
      end
      
      def has_format?(format)
        @targets.has_key?(format)
      end
      
      # Return the filters chain associated with the given formatter and output format.
      def filters_for(format, formatter = @formatter)
        process_filter_key('filter', format) || default_filter_chain_for(formatter, format)
      end

      # Return the post filters chain associated with the given format.
      def post_filters_for(format, formatter = @formatter)
        process_filter_key('postfilter', format) || default_postfilter_chain_for(formatter, format)
      end

      def target_for(format)
        @targets[format][:target_fn]
      end
      
      def deps_for(format)
        @deps[format]
      end

      def format
        @current_format || @default_format
      end

      def render?
        if @configuration.has_key?('render')
          return false unless @configuration['render']
        end
        true
      end

      # Render the document in the specified format.
      def render(args = { })
        args = { :format => @default_format }.merge args
        @current_format = args[:format]
        args.has_key?(:partial) ? render_partial(args[:partial], args[:format]) : do_render!(@formatter, args[:format])
      end
      
      # Return the content of the source document file.
      def source
        @source ||= read_source
      end
      
      private

      def method_missing(meth)
        if @configuration.has_key?(meth.to_s)
          @configuration[meth.to_s]
        else
          @logger.warn("Configuration key '#{meth.to_s}' is not defined for #{source_fn}.")
          @default_configuration_value
        end
      end

      def init_default(configuration)
        @configs = []
        @targets = { }
        @layouts = { }
        @deps = { }
        
        @default_config_ext = '.yaml'
        @default_format = 'html'
        @default_formatter = 'deplate'
        @default_configuration_value = 'not defined'
        @configuration = { 'layout' => relative_name }.merge configuration
      end
      
      # Get basename stripping out path and extension from +source_fn+
      def basename
        File.basename(source_fn, File.extname(source_fn))
      end

      # Get the directory part of source_fn
      def dirname
        File.dirname(source_fn)
      end

      def name_noext
        File.join(dirname, basename)
      end

      # Get name relative to configuration.document_dir
      def relative_name
        filename_helper(name_noext, @env_configuration[:document_dir], '')        
      end

      def add_config(fn)
        File.exists?(fn) ? merge_configuration_file(fn) : @logger.error("Configuration file '#{fn}' not found for '#{@source_fn}'!")
      end

      def add_layout(name, format = @default_format)
        if File.exists?(get_layout_filename(name, format))
          @layouts[format] << get_layout_filename(name, format)
        else
          @logger.debug("Layout file '#{get_layout_filename(name, format)}' does not exist for '#{source_fn}'.")
        end
      end

      def default_filter_chain_for(formatter, format)
        @env_configuration[:default_filter_chain][formatter][format]        
      end

      def default_postfilter_chain_for(formatter, format)
        @env_configuration[:default_postfilter_chain][formatter][format]
      end
      
      # @logger.error("Output format '#{format}' is not available for '#{formatter}' formatter.")
      # @logger.error("Formatter '#{formatter}' is not available.")
      
      def process_filter_key(key, format)
        @targets.has_key?(format) ? @targets[format][key] : nil
      end

      # Read the content of the source document file from disk.
      def read_source
        File.read(source_fn)
      end

      def process_config_configuration_key
        @configuration['config'].to_a.each { |fn| load_config_file(fn) }
      end

      def load_config_file(fn)
        config_fn = File.join(@env_configuration[:config_dir], fn)
        config_fn += @default_config_ext if File.extname(config_fn).empty?
        @configuration.delete('config')
        add_config(config_fn)
      end
      
      def merge_configuration_file(fn)
        fn == @source_fn ? @configuration.recursive_merge!(@header_configuration) : @configuration.recursive_merge!(YAML::load_file(fn))
        @configs << fn
        process_config_configuration_key if @configuration.has_key?('config')
      end
      
      def setup_header_configuration
        @header_configuration = extract_configuration_from_source!
      end
      
      # Setup targets hash initializing it with a default format.
      def setup_targets(format)
        @targets[format] = { :target_fn => target_fn(format) }
      end
      
      # Render document in the given format.
      def do_render!(formatter, format)
        render_source!(formatter, format)
        render_all_layouts!(format)
        @content_for_layout
      end
      
      # Produce output from source.
      def render_source!(formatter, format)
        @content_for_layout = apply_filters(@source, filters_for(format, formatter), format) unless @source.nil?
      end
      
      def render_layout!(layout_fn, format)
        @content_for_layout = apply_filters(File.read(layout_fn), post_filters_for(format), format) unless File.read(layout_fn).nil?
      end

      def render_partial(source_fn, format)
        document = @resource_factory.get(:document, File.join(@env_configuration[:document_dir], source_fn))
        @cache.add_dependency(@source_fn, format, document.source_fn)
        document.render(:format => format)
      end
      
      # Injects rendered content from +source_fn+ in the layout chain.
      def render_all_layouts!(format)
        @layouts[format].each { |layout_fn| render_layout!(layout_fn, format) } unless !@layouts[format] || @layouts[format].empty?
      end
      
      # Collect all dependencies.
      def collect_all
        collect_formats
        collect_layouts
        collect_deps
      end
      
      # Configure the document reading all the configuration files.
      # Configuration infos are read in this order:
      # 1. configuration in header if present.
      # 2. configuration in ./+basename+.yaml if file exists.
      # 3. configuration in COMMON.yaml file (or files) exist.
      # 4. configuration in doc/configs/+basename+.yaml if file exists.
      def configure # :doc:
        setup_header_configuration
        setup_targets(@default_format)

        add_config(config_fn_relative_to(:config_dir)) if File.exists?(config_fn_relative_to(:config_dir))
        add_common_config
        add_config(config_fn_relative_to(:document_dir)) if File.exists?(config_fn_relative_to(:document_dir))
        add_config(@source_fn) if @header_configuration
        
        @formatter = @configuration['formatter'] || @default_formatter
        
        collect_all
        @configuration
      end
      
      # Collect the layout files traversing +targets+ hash.
      def collect_layouts
        @targets.each_key do |format|
          @layouts[format] = []
          
          process_layout_configuration_key(format)

          @layouts[format].uniq!
          @layouts[format].compact!
        end
        @layouts
      end

      def process_layout_configuration_key(format)
        @configuration['layout'].to_a.each { |name| add_layout(name, format) }
      end

      def get_layout_filename(name, format)
        File.join(@env_configuration[:layout_dir], name + ".#{format.to_s}")
      end
      
      # Process +format+ key in configuration hash.
      def process_formats
        @targets = { }
        @configuration['format'].to_a.each do |format|
          @targets[format] = { :target_fn => target_fn(format) } if format.is_a?(String)
          @targets[format.keys.first] = process_format_configuration_key(format) if format.is_a?(Hash)
        end
      end
      
      # Process option hash related to a particular target.
      def process_format_configuration_key(format)
        format_key = format.keys.first
        opts = format.values.first
        ext = (opts['ext'] if opts.has_key?('ext')) || format_key
        filters =  (opts['filter'] if opts.has_key?('filter')) || default_filter_chain_for(@formatter, 'html')
        post_filters = (opts['postfilter'] if opts.has_key?('postfilter')) || default_postfilter_chain_for(@formatter, 'html')
        { :target_fn => target_fn(ext.to_sym), 'filter' => filters, 'postfilter' => post_filters }
      end
      
      # Iterates through configuration +:targets+ key (if
      # present) and setup target options.
      def collect_formats
        process_formats if @configuration.has_key?('format')
      end
      
      # Collect all the dependency.
      def collect_deps
        @targets.each do |format, target|
          @deps[format] = []
          @deps[format] << @source_fn # the essential dependency from source file
          @deps[format].concat @configs # dependency from configuration files
          @deps[format].concat @layouts[format] if @layouts.has_key?(format) # dependency from layout files
          @deps[format].concat @cache.deps[source_fn][format] if @cache.deps[source_fn] and @cache.deps[source_fn][format]
          @deps[format].uniq! # remove duplicates
        end
        @deps
      end
      
      # Strip configuration from header (if present) and recursive
      # merge it in +configuration hash.
      def extract_configuration_from_source!
        header_configuration_regexp = /\A-{3}$(.*?)-{3}$/m
        header_configuration = source.scan(header_configuration_regexp).to_s
        source.sub!(header_configuration_regexp, '')
        header_configuration = YAML::load(header_configuration)
      end
      
      # Configure from commons configuration files.
      def add_common_config
        resolve_common_configs(dirname).reverse.each do |file|
          add_config(file)
        end
      end
      
      # Collect common configuration files COMMON.yaml.
      def resolve_common_configs(dir, arr = [])
        parent = File.expand_path(File.join(dir, '..'))
        resolve_common_configs(parent, arr) unless parent == dir # at root
        fn = File.join(dir,'COMMON.yaml')
        arr << File.expand_path(fn) if (File.exists?(fn) && File.readable?(fn))
        arr.reverse!
      end
      
      # Return configuration filename from +source_fn+.
      #
      # Example:
      #
      # source_fn = 'doc/pages/subdir/document.ext'
      # config_fn #=> 'doc/configs/subdir/document.yaml'
      #
      def config_fn_relative_to(dir_config_key)
        filename_helper(name_noext, @env_configuration[:document_dir], @env_configuration[dir_config_key], @default_config_ext)
      end
      
      # Return target filename for a given format.
      #
      # Example:
      #
      # source_fn = 'doc/pages/document.ext'
      # format = 'html'
      # target_fn(format) #=> 'output/document.html'
      #
      def target_fn(format)
        filename_helper(name_noext, @env_configuration[:document_dir], @env_configuration[:output_dir], ".#{format.to_s}")
      end
      
      # Apply filters on text to produce the given format.
      def apply_filters(text, filters_chain, format)
        filters_chain.collect { |filter| @filter_factory.get(filter, self) }.inject(text) { |s, f| f.filter(s) }
      end
      
    end
  end
end

