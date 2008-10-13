#
# File 'application.rb' created on 08 mag 2008 at 17:26:07.
#
# See 'dokkit.rb' or +LICENSE+ for licence information.
#
# (C)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors).
#

require 'getoptlong'
require 'fileutils'
require 'dokkit'

module Dokkit
  class Application

    class << self
      
      def get_modelname_from(path)
        File.basename(path)
      end
      
      def get_model_dir_from(array_of_path)
        array_of_path.select { |path| path =~ /\.?dokkit-?/ }.collect { |path| File.join(path, 'models')}
      end
      
      def get_models_from(array_of_path)
        models = { }
        get_model_dir_from(array_of_path).each do |model_path|
          Dir.glob(File.join(model_path, '*')).each do |model_path|
            name = get_modelname_from(model_path)
            models[name] = model_path
          end
        end
        models
      end
      
    end
    
    OPTIONS =  [
                [ "--usage", "-u", GetoptLong::NO_ARGUMENT,
                  "Display usage information." ],
                [ "--help", "-h", GetoptLong::NO_ARGUMENT,
                  "Synonim for usage."],
                [ "--version", "-v", GetoptLong::NO_ARGUMENT,
                  "Display the version number and quit." ],
                [ "--list", '-l', GetoptLong::NO_ARGUMENT,
                  "List the available models."],
                [ "--model", '-m', GetoptLong::REQUIRED_ARGUMENT,
                  "Specify a documentation model" ]
               ]

    USAGE_PREAMBLE = <<-EOU
Usage: dokkit [options] <dest_dir>

Where dest_dir is the directory in which to setup the documentation
environment.

EOU
    attr_reader :default_model

    def initialize(logger, configuration = { })
      @logger = logger
      @configuration = configuration
      @user_dir = configuration[:user_dir] || relative_to_home('.dokkit')
      @model_dir = configuration[:model_dir] || 'models'
      @default_model = configuration[:default_model] || 'simple'
    end

    def models
      Application::get_models_from(Gem.latest_load_paths.push(@user_dir))
    end
    
    def run
      
      process_args
      
      unless ARGV.empty?
        create_environment(ARGV.to_s)
      else
        do_option('--help')        
      end

    end

    private

    def relative_to_home(path)
      File.join(((ENV['HOMEPATH'] if RUBY_PLATFORM =~ /win32/) || ENV['HOME']), path)
    end

    def create_environment(dest_dir)
      model = @model || @default_model
      if models.has_key?(model)
        unless File.exists?(dest_dir)
          @logger.info("Creating documentation environment based on '#{model}' on directory '#{dest_dir}'.")
          FileUtils.cp_r(models[model], dest_dir)
        else
          @logger.error("Directory '#{dest_dir}' already exists.")
        end
      else
        @logger.error("Model '#{model}' not found.")
      end
    end

    def do_option(option, value = nil)
      case option
      when '--usage'
        help
        exit
      when '--help'
        help
        exit
      when '--version'
        puts "dokkit, version #{Dokkit::VERSION}\n"
        exit
      when '--list'
        list_models
        exit
      when '--model'
        @model = value
      end
    end

    def command_line_options
      OPTIONS.collect { |lst| lst[0..-2] }
    end

    def process_args
      opts = GetoptLong.new(*command_line_options)
      opts.each { |opt, value| do_option(opt, value) }
    end

    def help
      puts
      puts USAGE_PREAMBLE
      puts "Recognized options are:"
      puts
      OPTIONS.sort.each do |long, short, mode, desc|
        if mode == GetoptLong::REQUIRED_ARGUMENT
          if desc =~ /\b([A-Z]{2,})\b/
            long = long + "=#{$1}"
          end
        end
        printf "  %-20s (%s)\n", long, short
        printf "      %s\n", desc
        puts
      end
    end
    
    def list_models
      models.each_key { |model| @logger.info("Found model '#{model}'.") }
    end

  end
end
