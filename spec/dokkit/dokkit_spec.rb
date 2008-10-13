#                                                                          
# File 'dokkit_spec.rb' created on 08 mag 2008 at 17:03:32.                    
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (c)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../lib')))

require 'rubygems'
require 'spec'
require 'dokkit'

describe Dokkit do
  it 'should set version number' do
    VERSION.should match(/\d.\d.\d/)
  end
end


