#                                                                          
# File 'factory_spec.rb' created on 25 apr 2008 at 19:42:47.                    
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (c) 2006, 2007, 2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          
# To execute this spec run:                                            
#                                                                          
# spec spec/factory_spec.rb                                                  
#                                                                          


$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../../../lib')))

require 'rubygems'
require 'spec'
require 'dokkit/factory/factory'
require 'spec/spec_helper.rb'

describe Dokkit::Factory do
  include SpecHelper::Logger, SpecHelper::Cache, SpecHelper::Configuration, SpecHelper::Resource

  before do
    class Foo
      attr_reader :arg1, :arg2
      def initialize(arg1, arg2)
        @arg1, @arg2 = arg1, arg2
      end
    end
    @foo_factory_method = lambda { |arg1, arg2| Foo.new(arg1, arg2) } 
  end
  
  describe ' when adding new factory method' do  
    
    before do
      @factory = Dokkit::Factory.new
    end
    
    it 'should add new factory method for a particular class of objects' do
      @factory.add(:foo, &@foo_factory_method)
      @factory.methods[:foo].should == @foo_factory_method
    end
    
  end
  
  describe ' when client require an object instance' do
  
    before do
      @factory = Dokkit::Factory.new do |factory| 
        factory.add(:foo, &@foo_factory_method)
      end
    end
    
    it 'should construct an instance for the given class' do
      instance = @factory.get(:foo, 'arg1', 'arg2')
      instance.is_a?(Foo).should be_true
    end
    
    it 'should correctly process constructor arguments' do
      instance = @factory.get(:foo, 'arg1', 'arg2')
      instance.arg1.should == 'arg1'
      instance.arg2.should == 'arg2'
    end
    
    it 'should correctly store instances' do
      instance_1 = @factory.get(:foo, 'arg1', 'arg2')
      instance_2 = @factory.get(:foo, 'arg3', 'arg4')
      @factory.instances.should == { [:foo, 'arg1', 'arg2'] => instance_1, [:foo, 'arg3', 'arg4'] => instance_2}
    end
    
    it 'should instantiate only one object for a given class and arguments set' do
      instance_1 = @factory.get(:foo, 'arg1', 'arg2')    
      instance_1.object_id.should == @factory.get(:foo, 'arg1', 'arg2').object_id
      instance_1.object_id.should_not == @factory.get(:foo, 'arg3', 'arg4').object_id
      instance_1.object_id.should == @factory.get(:foo, 'arg1', 'arg2').object_id
    end
  
  end
end


