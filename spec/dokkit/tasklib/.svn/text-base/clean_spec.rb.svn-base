#                                                                          
# File 'clean_spec.rb' created on 14 apr 2008 at 16:00:41.                    
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (c)2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          
# To execute this spec run:                                            
#                                                                          
# spec spec/clean_spec.rb                                                  
#                                                                          

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../../../lib')))

require 'rubygems'
require 'rake'
require 'spec'
require 'dokkit/tasklib/clean'
require 'spec/spec_helper.rb'

describe Dokkit::TaskLib::Clean do
  include SpecHelper::Logger
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
    @clean = Dokkit::TaskLib::Clean.new do |task|
      task.logger = @logger
      task.cache_dir = '.cache'
      task.output_dir = 'output'
    end
  end 
  after do
    Rake.application.clear
  end
  it 'should define a clean:output task' do
    @rake.tasks.should include(task('clean:output'))
  end
  it 'should define a clean:cache task' do
    @rake.tasks.should include(task('clean:cache'))
  end
  it 'should define a clean:all task' do
    @rake.tasks.should include(task('clean:all'))
  end  
  describe ' when clean:output is invoked' do
    before do
      mkdir 'output'
    end
    after do
      rm_rf 'output'
    end
    it 'should remove output directory' do
      @logger.stub!(:info)
      @rake['clean:output'].execute({ })
      File.exists?('output').should be_false
    end
  end
  describe ' when clean:cache is invoked' do
    before do
      mkdir '.cache'
    end
    after do
      rm_rf '.cache'
    end
    it 'should remove cache directory' do
      @logger.stub!(:info)
      @rake['clean:cache'].execute({ })
      File.exists?('.cache').should be_false
    end
  end
 end



