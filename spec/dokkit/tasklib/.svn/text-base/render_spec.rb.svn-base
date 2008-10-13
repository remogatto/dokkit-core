#
# File 'rendertask_spec.rb' created on 18 feb 2008 at 19:55:16.
# See 'dokkit.rb' or +LICENSE+ for licence information.
#
# (c)2006, 2007, 2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors).
#
# To execute this spec run:
#
# spec spec/render_spec.rb
#

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../../../lib')))

require 'rubygems'
require 'spec'
require 'dokkit/tasklib/render'
require 'spec/spec_helper.rb'

describe Dokkit::TaskLib::Render, ' when initialized' do

  before do
    @rake = Rake.application
    @rendertask = Dokkit::TaskLib::Render.new    
  end

  after do
    Rake.application.clear
  end

  it 'should define a render:doc task' do
    @rake['render:doc'].should
  end
  it 'should define a render:data task' do
    @rake['render:data'].should
  end
  it 'should define a render:all task' do
    @rake['render:all'].prerequisites.should == ['render:doc', 'render:data']
  end

end

describe Dokkit::TaskLib::Render, ' when invoking task' do
  
  include SpecHelper::Resource

  before(:all) do
    @initial_dir = Dir.pwd
    Dir.chdir(File.join(File.dirname(__FILE__), SpecHelper::Path::TEST_DATA))
  end

  after(:all) do
    Dir.chdir(@initial_dir)
  end

  before do
    @logger = logger
    @rake = Rake.application
    @rendertask = Dokkit::TaskLib::Render.new do |task|
      task.logger = logger
      task.document_fns = ['document_1', 'document_2', 'document_3']
      task.data_fns = ['data_1']
    end
    @rendertask.stub!(:need_update?).and_return(true)
  end

  after do
    Rake.application.clear
    rm_rf 'output'
  end

  describe ' render:doc' do
    
    before do
      @document_1 = document_1
      @document_2 = document_2
      @document_3 = document_3
      @rendertask.resource_factory = @resource_factory = resource_factory
    end
    
    it 'should render document_1.html, document_1.text, document_2.html' do
      @resource_factory.should_receive(:get).with(:document, 'document_1').and_return(@document_1)
      @resource_factory.should_receive(:get).with(:document, 'document_2').and_return(@document_2)
      @resource_factory.should_receive(:get).with(:document, 'document_3').and_return(@document_3)
      @document_1.should_receive(:render).with(:format => 'html')
      @document_1.should_receive(:render).with(:format => 'text')
      @document_2.should_receive(:render).with(:format => 'html')
      @document_3.should_not_receive(:render).with(:format => 'html')
      @rake['render:doc'].execute({ })
    end
  
  end

  describe ' render:data' do
    
    before do
      @data_1 = data_1
      @rendertask.resource_factory = @resource_factory = resource_factory
    end
    
    it 'should copy data_1 in output dir' do
      @resource_factory.should_receive(:get).with(:data, 'data_1').and_return(@data_1)
      @rendertask.should_receive(:mkdir_p).with('output', :verbose => false)
      @rendertask.should_receive(:cp).with('data_1', 'output/data_1', anything)
      @rake['render:data'].execute({ })
    end
  
  end

end

describe Dokkit::TaskLib::Render, ' up to date check' do

  include SpecHelper::Resource
  
  before do
    @rake = Rake.application
    @rendertask = Dokkit::TaskLib::Render.new do |task|
      task.logger = logger
      task.document_fns = ['document_1']
      task.resource_factory = @resource_factory = resource_factory
    end
    @document_2 = document_2
    @resource_factory.stub!(:get).and_return(@document_2)
  end

  after do
    Rake.application.clear
    rm_rf 'output'
  end

  it 'should re-render the document if mtimes are different' do
    File.stub!(:mtime).and_return(Time.now, Time.now + 5)
    @document_2.should_receive(:render)
    @rake['render:doc'].execute({ })
  end

  it 'should not re-render the document if mtimes are the same' do
    now = Time.now
    File.should_receive(:exists?).with('output/document_2.html').and_return(true)
    File.should_receive(:mtime).twice.and_return(now)
    @document_2.should_not_receive(:render).with(:format => 'html')
    @rake['render:doc'].execute({ })
  end

end
