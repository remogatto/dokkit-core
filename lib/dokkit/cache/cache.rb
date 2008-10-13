#                                                                          
# File 'cachemanager.rb' created on 28 gen 2008 at 18:31:05.                    
#
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (C)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

require 'rake'
require 'yaml'

module Dokkit
  class Cache
    attr_reader :deps, :cache_dir, :cache_filename
    
    def initialize(cache_filename = 'deps.yaml', cache_dir = '.cache')
      @cache_filename = cache_filename
      @cache_dir = cache_dir
      @complete_cache_filename = File.join(cache_dir, cache_filename)
      load
      at_exit { save }
    end
    
    def add_dependency(source_fn, format, dep)
      @deps[source_fn] ||= { format => [] }
      @deps[source_fn][format] << dep unless (dep.nil? or @deps[source_fn][format].include?(dep))
    end
    
    def load
      @deps = load_from_yaml || { }
    end
    
    def save
      write_cache_to_file unless @deps.empty?
    end
    
    def clean
      @deps.clear
    end

    private

    def load_from_yaml
      YAML::load_file(@complete_cache_filename) if File.exists?(@complete_cache_filename)
    end
    
    def write_cache_to_file
      mkdir_p(cache_dir, :verbose => false) unless File.exists?(cache_dir)
      File.open(@complete_cache_filename, 'w') { |file| file.write YAML::dump(@deps) }
    end
            
  end
end
