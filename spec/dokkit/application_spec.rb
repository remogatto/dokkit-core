#                                                                          
# File 'application_spec.rb' created on 08 mag 2008 at 17:26:24.                    
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (c)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../../lib')))

require 'rubygems'
require 'spec'
require 'dokkit/application'
require 'spec/spec_helper'

describe Dokkit::Application do
  it 'should return modelname from path' do
    Dokkit::Application.get_modelname_from('/usr/lib/ruby/gems/1.8/gems/dokkit-0.0.0/lib/models/simple/').should == 'simple'
  end
  
  it 'should return models dir' do
    Dokkit::Application.get_model_dir_from(['/home/user/.dokkit',
                                                   '/libpath/dokkit-0.0.0/lib', 
                                                   '/libpath/dokkit-modelgem-0.0.0/lib',
                                                   '/libpath/othergem-0.0.0/lib']).should == ['/home/user/.dokkit/models',
                                                                                              '/libpath/dokkit-0.0.0/lib/models', 
                                                                                              '/libpath/dokkit-modelgem-0.0.0/lib/models']
  end

  it 'should return models hash' do
    Dir.stub!(:glob).and_return(['/home/user/.dokkit/models/model1', '/home/user/.dokkit/models/model2'])
    Dokkit::Application.get_models_from(['/home/user/.dokkit',
                                         '/libpath/dokkit-0.0.0/lib', 
                                         '/libpath/dokkit-modelgem-0.0.0/lib',
                                         '/libpath/othergem-0.0.0/lib']).should == { 
      'model1' => '/home/user/.dokkit/models/model1',
      'model2' => '/home/user/.dokkit/models/model2'
    }
  end

end

describe Dokkit::Application, ' options behaviour' do
  include SpecHelper::CaptureOutput, SpecHelper::Logger
  before(:all) do
    @initial_dir = Dir.pwd
    Dir.chdir(File.join(File.dirname(__FILE__), SpecHelper::Path::TEST_DATA))
  end
  after(:all) do
    Dir.chdir(@initial_dir)
  end
  before do
    @logger = logger
    Dir.stub!(:glob).and_return(['/home/user/.dokkit/models/model1', '/home/user/.dokkit/models/model2'])
    Gem.stub!(:latest_load_paths).and_return(['/home/user/.dokkit',
                                              '/libpath/dokkit-0.0.0/lib', 
                                              '/libpath/dokkit-modelgem-0.0.0/lib',
                                              '/libpath/othergem-0.0.0/lib'])

    @dokkit = Dokkit::Application.new(@logger, { :dokkit_dir => 'dokkit', :model_dir => 'models', :default_model => 'model1' })
  end
  after do
    ARGV.clear
  end

  it 'should set default model' do
    @dokkit.default_model.should == 'model1'
  end
  
  it 'should display version number' do
    ARGV << '--version'
    capture_stdout do
      lambda do
        @dokkit.run
      end.should raise_error(SystemExit)
    end.should match(/dokkit, version \d.\d.\d/)
  end
  
  #FIXME: Code duplication here ...
  it 'should alias --help option with --usage' do
    ARGV << '--help'
    @output = capture_stdout do
      lambda do
        @dokkit.run
      end.should raise_error(SystemExit)
    end
    @output.should match(/Usage: dokkit/)
    @output.should match(/Recognized options/)
  end
  
  it 'should display usage information' do
    ARGV << '--usage'
    @output = capture_stdout do
      lambda do
        @dokkit.run
      end.should raise_error(SystemExit)
    end
    @output.should match(/Usage: dokkit/)
    @output.should match(/Recognized options/)
  end
  
  it 'should display the list of available models' do
    ARGV << '--list'
    @logger.should_receive(:info).with(/model/).twice
    lambda do 
      @dokkit.run
    end.should raise_error(SystemExit)
  end
  
  it 'should fail if the number of commandline argument is less than one' do
    @output = capture_stdout do
      lambda do 
        @dokkit.run
      end.should raise_error(SystemExit)
    end
  end
  
end

describe Dokkit::Application, ' creating new documentation environment based on a given model' do
  include SpecHelper::CaptureOutput, SpecHelper::Logger
  before(:all) do
    @initial_dir = Dir.pwd
    Dir.chdir(File.join(File.dirname(__FILE__), SpecHelper::Path::TEST_DATA))
  end
  after(:all) do
    Dir.chdir(@initial_dir)
  end
  before do
    Gem.stub!(:latest_load_paths).and_return(['/home/user/.dokkit',
                                              '/libpath/dokkit-0.0.0/lib', 
                                              '/libpath/dokkit-modelgem-0.0.0/lib',
                                              '/libpath/othergem-0.0.0/lib'])

    @logger = logger
    @dokkit = Dokkit::Application.new(@logger)
  end
  after do
    ARGV.clear
    FileUtils.rm_rf 'project'
  end
  it 'should copy builtin model directory structure on destination dir' do
    ARGV << 'project'
    Dir.stub!(:glob).and_return(['/libpath/dokkit-0.0.0/lib/models/simple'])
    FileUtils.should_receive(:cp_r).with('/libpath/dokkit-0.0.0/lib/models/simple', 'project')
    @dokkit.run
  end

  it 'should copy user model directory structure on destination dir' do
    ARGV.concat(['--m', 'user_model', 'project'])
    Dir.stub!(:glob).and_return(['/home/user/.dokkit/models/user_model'])
    FileUtils.should_receive(:cp_r).with('/home/user/.dokkit/models/user_model', 'project')
    @dokkit.run
  end

  it 'should fail if the destination directory exists' do
    ARGV << 'project'
    FileUtils.mkdir 'project'
    Dir.stub!(:glob).and_return(['/libpath/dokkit-0.0.0/lib/models/simple'])
    @logger.should_receive(:error).with(/already exists/)
    @dokkit.run
  end
  
  it 'should fail if not existent model is specified' do
    ARGV.concat(['--model', 'notexists', 'project'])
    @logger.should_receive(:error).with(/not found/)
    @dokkit.run
  end

end
