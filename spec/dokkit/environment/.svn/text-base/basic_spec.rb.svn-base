#                                                                          
# File 'environment_spec.rb' created on 01 mag 2008 at 15:34:55.                    
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (c) 2006, 2007, 2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          
# To execute this spec run:                                            
#                                                                          
# spec spec/environment_spec.rb                                                  
#                                                                          

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../../../lib')))

require 'rubygems'
require 'spec'
require 'dokkit/environment'
require 'spec/spec_helper.rb'

include Dokkit::Environment

describe Dokkit::Environment::Basic do 
  
  include SpecHelper::Path
  
  before(:all) do
    @initial_dir = Dir.pwd
    Dir.chdir(File.join(File.dirname(__FILE__), SpecHelper::Path::TEST_DATA))
  end
  
  after(:all) do
    Dir.chdir(@initial_dir)
  end
  
  before do
    @rake = Rake.application
  end
  
  before do
    @container = environment
    @container.logger.level = Dokkit::Logging::OFF
  end

  after do
    Rake.application.clear
  end  
  
  it 'should add lib folder to $:' do
    $:.should include('lib')
  end

  it 'should initialize a console logger' do
    @container.logger.is_a?(Dokkit::Logging::Logger).should be_true
  end

  it 'should set default directories in configuration struct' do
    @container.configuration.document_dir.should == 'doc/pages'
    @container.configuration.layout_dir.should == 'doc/layouts'
    @container.configuration.config_dir.should == 'doc/configs'
    @container.configuration.data_dir.should == 'doc/data'
    @container.configuration.cache_dir.should == '.cache'
    @container.configuration.output_dir.should == 'output' 
  end

  it 'should set default filter chain' do
    @container.configuration.default_filter_chain.should == { 
      'deplate' => { 'html' => ['erb', 'deplate-html'], 'latex' => ['erb', 'deplate-latex'], 'text' => ['erb', 'deplate-text'] },
      'maruku' => { 'html' => ['erb', 'maruku-html'], 'latex' => ['erb', 'maruku-latex'] },
      'haml' => { 'html' => ['haml'] }
    }  
  end

  it 'should set default postfilter chain' do
    @container.configuration.default_postfilter_chain.should == { 
      'deplate' => {'html' => ['erb'], 'latex' => ['erb'], 'text' => ['erb'] },
       'maruku' => {'html' => ['erb'], 'latex' => ['erb'], 'text' => ['erb'] },
       'haml' => {'html' => ['haml'] }
    }  
  end

  it 'should set default document filelist' do
    @container.document_fs.files.sort.should == ['doc/pages/document_1', 'doc/pages/document_2', 'doc/pages/subdir/document_1']
  end

  it 'should set default data filelist' do
    @container.data_fs.files.sort.should == ['doc/data/data']
  end

  it 'should construct a filter factory' do
    @container.filter_factory.is_a?(Dokkit::Factory).should be_true
  end
  
  it 'should construct a ERB filter instance through filter factory' do
    @container.filter_factory.get('erb', binding).is_a?(Dokkit::Filter::ERB).should be_true
  end
  
  it 'should construct a DeplateHTML filter instance through filter factory' do
    @container.filter_factory.get('deplate-html').is_a?(Dokkit::Filter::DeplateHTML).should be_true
  end
  
  it 'should construct a DeplateText filter instance through filter factory' do
    @container.filter_factory.get('deplate-text').is_a?(Dokkit::Filter::DeplateText).should be_true
  end
  
  it 'should construct a DeplateLatex filter instance through filter factory' do
    @container.filter_factory.get('deplate-latex').is_a?(Dokkit::Filter::DeplateLatex).should be_true
  end
  
  it 'should construct a MarukuHTML filter instance through filter factory' do
    @container.filter_factory.get('maruku-html').is_a?(Dokkit::Filter::MarukuHTML).should be_true
  end
  
  it 'should construct a Tidy filter instance through filter factory' do
    @container.filter_factory.get('tidy').is_a?(Dokkit::Filter::Tidy).should be_true
  end

  it 'should construct a Haml filter instance through filter factory' do
    @container.filter_factory.get('haml').is_a?(Dokkit::Filter::Haml).should be_true
  end

  it 'should construct a resource factory' do
    @container.resource_factory.is_a?(Dokkit::Factory).should be_true
  end

  it 'should set a block that construct a document instance' do
    @container.document_factory_block.call(document_path('document_1')).is_a?(Dokkit::Resource::Document).should be_true
  end

  it 'should set a block that construct a data instance' do
    @container.data_factory_block.call(data_path('data')).is_a?(Dokkit::Resource::Data).should be_true
  end

  it 'should define render tasklib' do
    @rake.tasks.should include(task('render:all'))
    @rake.tasks.should include(task('render:data'))
  end

  it 'should define clean tasklib' do
    @rake.tasks.should include(task('clean:all'))
    @rake.tasks.should include(task('clean:output'))
    @rake.tasks.should include(task('clean:cache'))
  end

  it 'should allow client code to change configuration struct' do
    @container.configure do |configure|
      configure.document_dir = 'doc/content'
    end
    @container.configuration.document_dir.should == 'doc/content'
  end

  it 'should allow client to include/exclude documents' do
    @container.select_document do |selection|
      selection.include('*')
      selection.exclude('*.yaml')
    end
    @container.document_fs.files.should == ['doc/pages/document_1', 'doc/pages/document_2']
  end
  
  it 'should allow client to include/exclude data files' do
    @container.select_data do |selection|
      selection.include('*')
    end
    @container.data_fs.files.should == ['doc/data/data']
  end

  it 'should allow client to extend selected documents' do
    module HTML
      def extension; end
    end
    @container.extend_document 'document_1', HTML
    @container.resource_factory.get(:document, 'doc/pages/document_1').respond_to?(:extension).should be_true
  end
end
