#
# File 'document_spec.rb' created on 17 apr 2008 at 18:01:58.
# See 'dokkit.rb' or +LICENSE+ for licence information.
#
# (c) 2006, 2007, 2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors).
#
# To execute this spec run:
#
# spec spec/document_spec.rb
#

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../../../lib')))

require 'rubygems'
require 'spec'
require 'dokkit/resource/document'
require 'spec/spec_helper.rb'

describe Dokkit::Resource::Document do

  include SpecHelper::Configuration, SpecHelper::Logger, SpecHelper::Cache

  before(:all) do
    @initial_dir = Dir.pwd
    Dir.chdir(File.join(File.dirname(__FILE__), SpecHelper::Path::TEST_DATA))
  end

  after(:all) do
    Dir.chdir(@initial_dir)
  end

  before do
    @document = Dokkit::Resource::Document.new('doc/pages/document', configuration) do |document|
      document.logger = logger
      document.cache = cache
    end
  end

  it 'should read config file with the same name of the document' do
    @document.configs.should include('doc/pages/document.yaml')
  end

  it 'should read config file with the same name of the document in configuration dir' do
    @document.configs.should include('doc/configs/document.yaml')
  end

  it 'should read common config files' do
    @document.configs.should include(File.expand_path('doc/pages/COMMON.yaml'))
  end

  it 'should give an interface to add configuration file' do
    @document.config('config')
    @document.configs.should include('doc/configs/config.yaml')
  end

  it 'should give an interface to change configuration on the fly' do
    @document.reconfigure('config' => 'config')
    @document.configs.should include('doc/configs/config.yaml')
  end

  it 'should setup configuration following an inner to outer order' do
    @document.configuration['key'].should == %w(configs/document.yaml COMMON.yaml document.yaml)
  end

  it 'should raise an error if a configuration file does not exist' do
    @document.logger = @logger = logger
    @logger.should_receive(:error).with(/configuration file.+not found/i)
    @document.config('notexists')
  end

  it 'should warn if a configuration key does not exist' do
    @document.logger = @logger = logger
    @logger.should_receive(:warn).with(/configuration key.+not defined/i)
    @document.configure['notexists']
  end
  
  it 'should return a configuration value through method_missing' do
    @document.reconfigure('title' => 'Title')
    @document.title.should == 'Title'
  end
  
  it 'should read html layout from layout dir' do
    @document.layouts['html'].should == ['doc/layouts/document.html']
  end

  it 'should read the given layout from layout dir' do
    @document.reconfigure('layout' => 'layout')
    @document.layouts['html'].should == ['doc/layouts/layout.html']
  end
  
  it 'should collect proper layouts in case of multi format document' do
    @document.reconfigure('layout' => 'layout', 'format' => ['html', 'text'])
    @document.layouts.should == { 'html' => ['doc/layouts/layout.html'], 'text' => ['doc/layouts/layout.text']}
  end

  it 'should raise a debug message  if a layout file does not exist' do
    @document.logger = @logger = logger
    @logger.should_receive(:debug).with(/layout file.+not exist/i)
    @document.layout('notexists')
  end

  it 'should give an interface to add layout' do
    @document.layout('layout')
    @document.layouts['html'].should == ['doc/layouts/layout.html']
  end
  
  it 'should know if it can render in a given format' do
    @document.reconfigure('format' => %w(text html))
    @document.has_format?('text').should be_true
    @document.has_format?('html').should be_true
  end
  
  it 'should know which is the current formatter' do
    @document.formatter.should == 'deplate'
    @document.reconfigure('formatter' => 'maruku')
    @document.formatter.should == 'maruku'
  end
  
  it 'should know which is the current format' do
    @document.format.should == 'html'
  end
  
  it 'should return the default filter chain for the given format and formatter' do
    @document.filters_for('html').should == ['erb', 'deplate-html']
    @document.filters_for('html', 'deplate').should == ['erb', 'deplate-html']
  end

  it 'should return the filter chain specified by user' do
    @document.reconfigure('format' => [ { 'html' => { 'filter' => 'custom_filter' } }]) 
    @document.filters_for('html').should == 'custom_filter'
  end

  it 'should return the filter chain associated with the formatter specified by user' do
    @document.reconfigure('formatter' => 'maruku')
    @document.filters_for('html').should == ['erb', 'maruku-html']
  end
  
#   it 'should raise an error if a given formatter does not exist' do
#     @document.logger = @logger = logger
#     @logger.should_receive(:error).with(/formatter.+is not available/i)
#     @document.filters_for('html', 'unknown')
#   end

#   it 'should raise an error if a given output format does not exist' do
#     @document.logger = @logger = logger
#     @logger.should_receive(:error).with(/output format.+is not available/i)
#     @document.filters_for('unknown')
#   end

  it 'should return the default postfilter chain for the given format and formatter' do
    @document.post_filters_for('html').should == ['erb']
  end

  it 'should return the proper postfilter chain' do
    @document.reconfigure('format' => [ { 'html' => { 'postfilter' => 'custom_filter' } } ] ) 
    @document.post_filters_for('html').should == 'custom_filter'
  end

  it 'should return the postfilter chain associated with the formatter specified by user' do
    @document.reconfigure('formatter' => 'haml')
    @document.post_filters_for('html').should == ['haml']
  end

#   it 'should raise an error if a client search for a postfilter chain associated with a non existent output format' do
#     @document.logger = @logger = logger
#     @logger.should_receive(:error).with(/output format.+is not available/i)
#     @document.post_filters_for('unknown')
#   end

  it 'should collect all dependencies grouped by format' do
    @document.reconfigure('format' => ['html', 'text'])
    @document.deps_for('html').should == %W{doc/pages/document doc/configs/document.yaml 
                                            #{File.expand_path('doc/pages/COMMON.yaml')} 
                                            doc/pages/document.yaml doc/layouts/document.html}
    @document.deps_for('text').should == %W{doc/pages/document doc/configs/document.yaml 
                                            #{File.expand_path('doc/pages/COMMON.yaml')} 
                                            doc/pages/document.yaml doc/layouts/document.text}

  end
  
  it 'should setup target filename' do
    @document.reconfigure('format' => ['html', 'text', 'custom'])
    @document.target_for('html').should == 'output/document.html'
    @document.target_for('text').should == 'output/document.text'    
    @document.target_for('custom').should == 'output/document.custom'    
  end
    
  it 'should set the render flag to true by default' do
    @document.render?.should be_true
  end

  it 'should read the render flag from configuration' do
    @document.reconfigure('render' => false)
    @document.render?.should be_false
  end

  it 'should return the current binding' do
    @document.get_binding.class.should == Binding
  end
  
  describe ' when a render message is sent' do
    
    include SpecHelper::Resource, SpecHelper::Filter
    
    before do
      @document.logger = @logger = logger
      @document.filter_factory = @filter_factory = filter_factory
    end
    
    it 'should render using default output format' do
      @filter_factory.should_receive(:get).with('erb', anything()).twice.and_return(filter)
      @filter_factory.should_receive(:get).with('deplate-html', anything()).and_return(filter)
      @document.render
    end
  
    it 'should render in the given format' do
      @document.reconfigure('format' => ['html', 'text'])
      @filter_factory.should_receive(:get).with('erb', anything()).exactly(4).and_return(filter)
      @filter_factory.should_receive(:get).with('deplate-text', anything()).and_return(filter)
      @filter_factory.should_receive(:get).with('deplate-html', anything()).and_return(filter)
      ['html', 'text'].each { |format| @document.render(:format => format) }     
    end

    it 'should render in the given format using the given filter chain' do
      @document.reconfigure('format' => ['html', 'text', { 'latex' => { 'filter' => ['deplate-latex'] } } ] )
      @filter_factory.should_receive(:get).with('erb', anything()).exactly(4).and_return(filter)
      @filter_factory.should_receive(:get).with('deplate-text', anything()).and_return(filter)
      @filter_factory.should_receive(:get).with('deplate-html', anything()).and_return(filter)
      @filter_factory.should_receive(:get).with('deplate-latex', anything()).and_return(filter)
      ['html', 'latex', 'text'].each { |format| @document.render(:format => format) }     
    end

    it 'should render the given partial' do
      @partial = mock('partial')
      @document.resource_factory = @resource_factory = resource_factory
      @document.cache = @cache = cache
      
      @resource_factory.should_receive(:get).with(:document, 'doc/pages/partial').and_return(@partial)
      @cache.should_receive(:add_dependency).with('doc/pages/document', 'html', 'doc/pages/partial')
      @partial.should_receive(:source_fn).and_return('doc/pages/partial')
      @partial.should_receive(:render)
      
      @document.render :partial => 'partial'
    end
    
#     it 'should raise an error if an unknown output format is specified' do
#       @document.reconfigure('format' => ['unknown'])
#       @logger.should_receive(:error).with(/format.+is unknown/i)
#       @document.render :format => 'unknown'
#     end
    
#     it 'should raise an error if an unknown output format is requested during render' do
#       @logger.should_receive(:error).with(/format.+is unknown/i)
#       @document.render :format => 'unknown'
#     end
    
  end
  
  
end
