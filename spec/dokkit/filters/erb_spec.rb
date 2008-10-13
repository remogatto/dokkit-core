#                                                                          
# File 'erb_spec.rb' created on 23 lug 2008 at 15:38:04.                    
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (c)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          #                                                                          
# To execute this spec run:                                            
#                                                                          
# spec spec/dokkit/filters/erb_spec.rb                                                  
#                                                                          

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../../../lib')))

require 'rubygems'
require 'spec'
require 'dokkit'
require 'dokkit/filters/erb'

describe Dokkit::Filter::ERB do
  before do
    @document = mock('document')
    @document.stub!(:get_binding)
    @erb = Dokkit::Filter::ERB.new(@document)
  end
  it 'should compile an erb template' do
    @erb.filter('<%= "process this" %>').should == "process this"
  end
end
