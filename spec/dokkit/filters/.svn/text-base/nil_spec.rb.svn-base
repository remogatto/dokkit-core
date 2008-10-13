#                                                                          
# File 'filter_nil_spec.rb' created on 18 mar 2008 at 12:39:00.                    
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (c)2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          
# To execute this spec run:                                            
#                                                                          
# spec spec/filter_nil_spec.rb                                                  
#                                                                          


$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../../../lib')))

require 'rubygems'
require 'spec'
require 'dokkit'
require 'dokkit/filters/nil'

describe Dokkit::Filter::Nil do
  before do
    @nil = Dokkit::Filter::Nil.new
  end
  it 'should not transform source file' do
    @result = @nil.filter('Do *not* transform this text.').should == 'Do *not* transform this text.'
  end
end


