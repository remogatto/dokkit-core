#                                                                          
# File 'container_spec.rb' created on 15 ago 2008 at 15:15:07.                    
# See 'dokkit.rb' or +LICENSE+ for license information.                      
#                                                                          
# (c)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../../../lib')))

require 'rubygems'
require 'spec'
require 'dokkit'
require 'spec/spec_helper'
require 'dokkit/environment/container'

describe Dokkit::Environment::Container do
  
  before do
    @container = Dokkit::Environment::Container.new
    @container.register(:service) do
      Object.new
    end
  end
  
  it 'should register new services' do
    @container[:service].class.should == Object
  end
  
  it 'should clean instance relative to a re-registered service' do
    old_id = @container[:service].object_id
    @container.register(:service) do
      Object.new
    end
    @container[:service].object_id.should_not == old_id
  end
  
  it 'should return only one instance of the given service' do
    @container[:service].object_id.should == @container[:service].object_id
  end
  
  it 'should return instance through method_missing' do
    @container.service.class.should == Object
  end
end

