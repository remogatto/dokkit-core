#                                                                          
# File 'filter_maruku_spec.rb' created on 15 feb 2008 at 22:52:14.                    
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (c)2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          
# To execute this spec run:                                            
#                                                                          
# spec spec/filter_maruku_spec.rb                                                  
#                                                                          


$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../../../lib')))

require 'rubygems'
require 'spec'
require 'dokkit'
require 'dokkit/filters/maruku'

describe Dokkit::Filter, ' maruku'do
  
  it 'should transform markdown text in html' do
    Dokkit::Filter::MarukuHTML.new.filter('# Header').should =~ /\<h1.*\>Header\<\/h1\>/
  end
  
  it 'should transform markdown text in latex' do
    Dokkit::Filter::MarukuLatex.new.filter('# Header').should =~ /\hypertarget/
  end

end

