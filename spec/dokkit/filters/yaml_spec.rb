#                                                                          
# File 'yaml_spec.rb' created on 18 ago 2008 at 14:58:16.                    
# See 'dokkit.rb' or +LICENSE+ for license information.                      
#                                                                          
# (c)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../../../lib')))

require 'rubygems'
require 'spec'
require 'dokkit'
require 'dokkit/hash'
require 'dokkit/filters/yaml'

describe Dokkit::Filter::YAML do
  
  before do
    @document = mock('document')
    @document.stub!(:configuration).and_return({ 'key' => ['value_1'] })
    @yaml = Dokkit::Filter::YAML.new(@document)
  end

  it 'should merge document configuration with yaml file configuration' do
    @yaml.filter("---\nkey:\n- value_2").should == nil
    @document.configuration.should == { 'key' => ['value_1', 'value_2']}
  end
  
end



