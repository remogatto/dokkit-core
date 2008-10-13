#                                                                          
# File 'consolelog_spec.rb' created on 23 feb 2008 at 16:40:31.                    
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (c) 2006, 2007, 2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          
# To execute this spec run:                                            
#                                                                          
# spec spec/consolelog_spec.rb                                                  
#                                                                          


$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../../../../lib')))

require 'rubygems'
require 'spec'
require 'dokkit'
require 'dokkit/logging/observers/console'
require 'spec/spec_helper.rb'

describe Dokkit::Logging::Observer::Console, ' when initialized' do
  it 'should reference to a logger instance and attach to it' do
    @logger = mock('logger')
    @logger.should_receive(:attach)
    @consolelog = Dokkit::Logging::Observer::Console.new(@logger)    
    @consolelog.logger.should_not be_nil
  end
end

describe Dokkit::Logging::Observer::Console, ' when logger notifies' do
  include SpecHelper::CaptureOutput
  before do
    @logger = mock('logger')
    @logger.stub!(:attach)
    @consolelog = Dokkit::Logging::Observer::Console.new(@logger)
  end
  describe ' an error message' do
    it 'should send the error message to the console' do
      @logger.stub!(:last_message).and_return({ :text => 'error message', :level => Dokkit::Logging::ERROR })
      lambda { @consolelog.update }.should raise_error(RuntimeError, /\[ERROR\] error message/)
    end
  end
  describe ' a warning message' do
    it 'should send the warning message to the console' do
      @logger.stub!(:last_message).and_return({ :text => 'warning message', :level => Dokkit::Logging::WARNING })
      capture_stderr do
        @consolelog.update
      end.should match(/\[WARNING\] warning message/)
    end
  end
  describe ' an info message' do
    it 'should send the info message to the console' do
      @logger.stub!(:last_message).and_return({ :text => 'info message', :level => Dokkit::Logging::INFO })
      capture_stdout do
        @consolelog.update
      end.should match(/\[INFO\] info message/)
    end
  end  
  describe ' a debug message' do
    it 'should send the debug message the console' do
      @logger.stub!(:last_message).and_return({ :text => 'debug message', :level => Dokkit::Logging::DEBUG })
      capture_stdout do
        @consolelog.update
      end.should match(/\[DEBUG\] debug message/)
    end
  end  
end

