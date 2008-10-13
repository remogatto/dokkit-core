#                                                                          
# File 'filter_deplate_spec.rb' created on 18 feb 2008 at 15:22:35.                    
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (c)2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          
# To execute this spec run:                                            
#                                                                          
# spec spec/filter_deplate_spec.rb                                                  
#                                                                          


$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../../../lib')))

require 'rubygems'
require 'spec'
require 'dokkit'
require 'dokkit/filters/deplate'

describe Dokkit::Filter::DeplateHTML do
  before do
    @deplate = Dokkit::Filter::DeplateHTML.new
  end
  it 'should transform deplate wiki text in html' do
    @deplate.filter('* Header').should =~ /\<h1.*\>1&nbsp;Header\<\/h1\>/
  end
end

describe Dokkit::Filter::DeplateLatex do
  before do
    @deplate = Dokkit::Filter::DeplateLatex.new
  end
  it 'should transform deplate wiki text in tex' do
    @deplate.filter('* Header').should =~ /\\section\{Header\}/
  end
end

describe Dokkit::Filter::DeplateText do
  before do
    @deplate = Dokkit::Filter::DeplateText.new
  end
  it 'should transform deplate wiki text in plain text' do
    @deplate.filter('* Header').should =~ /\n1 Header\n=+$/
  end
end


