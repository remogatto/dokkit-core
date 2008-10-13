#                                                                          
# File 'haml_spec.rb' created on 04 ago 2008 at 20:56:21.                    
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (c)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../../../lib')))

require 'rubygems'
require 'spec'
require 'dokkit'
require 'dokkit/filters/haml'

describe Dokkit::Filter::Haml do
  before do
    @document = mock('document')
    @document.stub!(:get_binding)
    @haml = Dokkit::Filter::Haml.new(@document)
  end
  it 'should compile an erb template' do
    @haml.filter('%p process this').should == "<p>process this</p>\n"
  end
end
