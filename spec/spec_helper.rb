#                                                                          
# File 'spec_helper.rb' created on 12 gen 2008 at 20:25:09.                    
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (c)2006, 2007 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../lib')))

require 'dokkit/hash'
require 'dokkit/resource/document'

module SpecHelper
  module Path
    TEST_DATA = 'test_data'
    DATA_DEST_DIR = 'data'
    CACHE_PATH = '.cache'
    DOCUMENT_PATH = 'doc/pages'
    DATA_PATH = 'doc/data'
    CONFIG_PATH = 'doc/configs'
    LAYOUT_PATH = 'doc/layouts'
    TEMPLATE_PATH = 'templates'
    OUTPUT_PATH = 'output'
    def base_path(fn = '')
      File.join('.', fn)
    end
    def cache_path(fn = '')
      File.join(base_path, CACHE_PATH, fn).sub(/^\.\//, '').sub(/\/$/, '')
    end
    def document_path(fn = '')
      File.join(base_path, DOCUMENT_PATH, fn).sub(/^\.\//, '').sub(/\/$/, '')
    end
    def config_path(fn = '')
      File.join(base_path, CONFIG_PATH, fn).sub(/^\.\//, '').sub(/\/$/, '')
    end
    def layout_path(fn = '')
      File.join(base_path, LAYOUT_PATH, fn).sub(/^\.\//, '').sub(/\/$/, '')
    end
    def data_path(fn = '')
      File.join(base_path, DATA_PATH, fn).sub(/^\.\//, '').sub(/\/$/, '')
    end
    def output_path(fn = '')
      File.join(base_path, OUTPUT_PATH, fn).sub(/^\.\//, '').sub(/\/$/, '')
    end      
  end
  module Logger
    def logger
      mock('logger', 
           :info  => nil,
           :error => nil,
           :warn  => nil,
           :debug => nil)
    end
  end
  module Cache
    def cache
      mock('cache', :load => nil, 
           :deps => { }, 
           :add_dependency => nil)
    end
  end
  module Filter
    def filter(output = nil)
      mock('filter', :filter => output)
    end
  end
  module Configuration
    def configuration
      { 
        :document_dir => 'doc/pages',
        :data_dir => 'doc/data',
        :layout_dir => 'doc/layouts',
        :config_dir => 'doc/configs',
        :cache_dir => '.cache',
        :output_dir => 'output',
        :default_filter_chain => { 
          'deplate' => { 'html' => ['erb', 'deplate-html'], 'latex' => ['erb', 'deplate-latex'], 'text' => ['erb', 'deplate-text']},
          'maruku' => { 'html' => ['erb', 'maruku-html'], 'latex' => ['erb', 'maruku-latex'], 'text' => ['erb', 'maruku-text']}
        },
        :default_postfilter_chain => { 
          'deplate' => { 'html' => ['erb'], 'latex' => ['erb'], 'text' => ['erb'] },
          'haml' => { 'html' => ['haml'] }
        }  

      }
    end
    def merge_hashes(*hashes)
      config = { }
      hashes.each do |hash|
        config.recursive_merge!(YAML::load(File.read(hash))) if File.exists?(hash.to_s)
        config.recursive_merge!(hash) if hash.is_a?(Hash)
      end
      config.delete('config')
      config
    end
  end
  module CaptureOutput
    def capture_stdout
      s = StringIO.new
      oldstdout = $stdout
      $stdout = s
      yield
      s.string
    ensure
      $stdout = oldstdout    
    end
    def capture_stderr
      s = StringIO.new
      oldstdout = $stderr
      $stderr = s
      yield
      s.string
    ensure
      $stderr = oldstdout    
    end      
  end
  module Resource
    include Path, Configuration, Logger, Cache, Filter
    
    def create_document(config = nil, args = { })
      
      args = { :document => document_path('document'),
               :logger => logger,
               :cache => cache,
               :resource_factory => resource_factory,
               :filter_factory => filter_factory }.merge(args)
      Dokkit::Resource::Document.new(args[:document], 
                                     configuration.recursive_merge(config), 
                                     args[:logger],
                                     args[:cache], 
                                     args[:resource_factory], 
                                     args[:filter_factory])      
    end
    
    def document_1
      mock('document_1', 
           :source_fn => 'doc/pages/document_1',
           :targets => { 'html' => nil, 'text' => nil },
           :target_for => 'output/document_1.html',
           :deps_for => ['doc/pages/document_1'],
           :render? => true,
           :render => nil
           )
    end
    def document_2
      mock('document_2', 
           :source_fn => 'doc/pages/document_2',
           :targets => { 'html' => nil },
           :target_for => 'output/document_2.html',
           :deps_for => ['doc/pages/document_2'],
           :render? => true,
           :render => nil
           )
    end
    def document_3
      mock('document_3', 
           :source_fn => 'doc/pages/document_3',
           :targets => { 'html' => nil },
           :target_for => 'output/document_3.html',
           :deps_for => ['doc/pages/document_3'],
           :render? => false,
           :render => nil
           )
    end
    def data_1
      mock('data_1', 
           :target_fn => 'output/data_1', 
           :source_fn => 'data_1'
           )
    end
    def resource_factory
      mock('resource_factory')
    end
    def filter_factory
      mock('filter_factory')
    end
  end
end
