#                                                                          
# File 'cachemanager_spec.rb' created on 28 gen 2008 at 18:31:31.                    
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (c)2006, 2007 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          
# To execute this spec run:                                            
#                                                                          
# spec spec/cachemanager_spec.rb                                                  
#                                                                          


$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__),'../../../lib'))

require 'rubygems'
require 'spec'
require 'dokkit'
require 'dokkit/cache'
require 'spec/spec_helper'

describe Dokkit::Cache do
  include SpecHelper::Path

  before(:all) do
    @initial_dir = Dir.pwd
    Dir.chdir(File.join(File.dirname(__FILE__), SpecHelper::Path::TEST_DATA))
  end
  after(:all) do
    Dir.chdir(@initial_dir)
  end

  describe ' when initialized' do
    before do
      mkdir '.cache_test' unless File.exists?('.cache_test')
      File.open(base_path('.cache_test/deps.rake'), 'w') do |file|
        file.write YAML::dump({ document_path('document_1') => { 'html' => [document_path('document_1.dep')] } } )
      end
      @cache = Dokkit::Cache.new('deps.rake', '.cache_test')
    end
    it 'should import the cache file (if exists)' do
      @cache.deps.should == { document_path('document_1') => { 'html' => [document_path('document_1.dep')] } }
    end
    after do
      @cache.clean
      rm_rf base_path('.cache_test')
    end
  end
  
  describe '#add_dependency' do
    before do
      @cache = Dokkit::Cache.new('deps.rake', '.cache_test')
    end  
    it 'should add dependecies to the given document' do
      @cache.add_dependency(document_path('document_1'), 'html', 'doc/pages/document_1.dep')
      @cache.deps.should == { document_path('document_1') => { 'html' => [document_path('document_1.dep')] } }
    end
    it 'should not add an existing dependency to the given document' do
      @cache.add_dependency(document_path('document_1'), 'html', 'doc/pages/document_1.dep')
      @cache.add_dependency(document_path('document_1'), 'html', 'doc/pages/document_1.dep')
      @cache.add_dependency(document_path('document_1'), 'html', 'doc/pages/document_2.dep')
      @cache.deps.should == { document_path('document_1') => { 'html' => ['doc/pages/document_1.dep', 'doc/pages/document_2.dep'] } }      
    end
    after do
      @cache.clean
      rm_rf '.cache_test'
      @cache = nil
    end      
  end
  
  describe '#save' do
    before do
      @cache = Dokkit::Cache.new('deps.rake', '.cache_test')
      @cache.add_dependency(document_path('document_1'), 'html', 'doc/pages/document_1.dep')
      @cache.add_dependency(document_path('document_1'), 'html', 'doc/pages/document_2.dep')
      @cache.add_dependency(document_path('document_1'), 'html', 'doc/pages/document_3.dep')
    end  
    it 'should save the dependencies to file' do
      @cache.save
      File.exists?(base_path('.cache_test/deps.rake')).should be_true
    end
    after do
      @cache.clean
      rm_rf '.cache_test'
    end  
    
  end
end
