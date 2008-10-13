#                                                                          
# File 'data_spec.rb' created on 16 apr 2008 at 20:03:08.                    
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (c)2006, 2007, 2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          
# To execute this spec run:                                            
#                                                                          
# spec spec/data_spec.rb                                                  
#                                                                          

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../../../lib')))

require 'rubygems'
require 'spec'
require 'dokkit/resource/data'
require 'spec/spec_helper.rb'

describe Dokkit::Resource::Data do
  before do
    @data = Dokkit::Resource::Data.new('doc/data/data_1')
  end
  it 'should respond to :source_fn' do
    @data.should respond_to(:source_fn)
  end
  it 'should respond to :configuration' do
    @data.should respond_to(:configuration)
  end
  it 'should return the target filename' do
    @data.target_fn.should == 'output/data_1'
  end
end
