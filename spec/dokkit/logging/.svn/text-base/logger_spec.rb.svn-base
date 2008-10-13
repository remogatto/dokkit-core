#                                                                          
# File 'logger_spec.rb' created on 23 feb 2008 at 15:47:50.                    
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (c)2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          
# To execute this spec run:                                            
#                                                                          
# spec spec/logger_spec.rb                                                  
#                                                                          

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../../../lib')))

require 'rubygems'
require 'spec'
require 'dokkit'
require 'dokkit/logging/logger'

describe Dokkit::Logging::Logger do
  before do
    @logger = Dokkit::Logging::Logger.new
    @observer = mock('observer')
  end
  it 'should be set with INFO log level by default' do
    @logger.level.should == Dokkit::Logging::INFO
  end
  it 'should fix log level if out of range' do
    @logger.level = 5
    @logger.level.should == Dokkit::Logging::DEBUG
    @logger.level = -2
    @logger.level.should == Dokkit::Logging::OFF
  end
  it 'should add observer to the observers list' do
    @logger.attach(@observer).should == @observer
    @logger.observers.should == [@observer]
  end
  it 'should remove the given observer from observers list' do
    @logger.attach(@observer)
    @logger.detach(@observer).should == @observer
    @logger.observers.should be_empty
  end
  it 'should send updated messages to the observers' do
    @observer.should_receive(:update)
    @logger.attach(@observer)
    @logger.notify
  end
end

describe Dokkit::Logging::Logger, ' when log level changes' do
  before do
    @logger = Dokkit::Logging::Logger.new
  end
  describe ' to OFF' do
    before do
      @logger.level = Dokkit::Logging::OFF
    end
    it 'should disable logging' do
      @logger.error('This is an error message.').should be_nil
      @logger.warn('This is a warning message').should be_nil
      @logger.info('This is an info message').should be_nil
      @logger.debug('This is a debug message').should be_nil
    end
  end
  describe ' to ERROR' do
    before do
      @logger.level = Dokkit::Logging::ERROR
    end
    it 'should send error messages only' do
      @logger.error('This is an error message.').should == { 
        :text => 'This is an error message.', 
        :level => Dokkit::Logging::ERROR 
      }
      @logger.warn('This is a warning message').should be_nil
      @logger.info('This is an info message').should be_nil
      @logger.debug('This is a debug message').should be_nil
    end
  end
  describe ' to WARNING' do
    before do
      @logger.level = Dokkit::Logging::WARNING
    end
    it 'should send error and warning messages only' do
      @logger.error('This is an error message.').should == { 
        :text => 'This is an error message.', 
        :level => Dokkit::Logging::ERROR 
      }
      @logger.warn('This is a warning message.').should == { 
        :text => 'This is a warning message.', 
        :level => Dokkit::Logging::WARNING 
      }
      @logger.info('This is an info message').should be_nil
      @logger.debug('This is a debug message').should be_nil        
    end  
  end
  describe ' to INFO' do
    before do
      @logger.level = Dokkit::Logging::INFO
    end
    it 'should send error, warning and info messages only' do
      @logger.error('This is an error message.').should == { 
        :text => 'This is an error message.', 
        :level => Dokkit::Logging::ERROR 
      }
      @logger.warn('This is a warning message.').should == { 
        :text => 'This is a warning message.', 
        :level => Dokkit::Logging::WARNING 
      }
      @logger.info('This is an info message.').should == { 
        :text => 'This is an info message.', 
        :level => Dokkit::Logging::INFO 
      }      
      @logger.debug('This is a debug message').should be_nil        
    end  
  end    
  describe ' to DEBUG' do
    before do
      @logger.level = Dokkit::Logging::DEBUG
    end
    it 'should send all messages' do
      @logger.error('This is an error message.').should == { 
        :text => 'This is an error message.', 
        :level => Dokkit::Logging::ERROR 
      }
      @logger.warn('This is a warning message.').should == { 
        :text => 'This is a warning message.', 
        :level => Dokkit::Logging::WARNING 
      }
      @logger.info('This is an info message.').should == { 
        :text => 'This is an info message.', 
        :level => Dokkit::Logging::INFO 
      }      
      @logger.debug('This is a debug message.').should == { 
        :text => 'This is a debug message.', 
        :level => Dokkit::Logging::DEBUG 
      }      
    end  
  end      
end
