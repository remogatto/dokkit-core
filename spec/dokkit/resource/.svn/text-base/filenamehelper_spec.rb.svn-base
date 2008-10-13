#                                                                          
# File 'filehelper_spec.rb' created on 28 feb 2008 at 16:44:07.                    
# See 'dokkit.rb' or +LICENSE+ for license information.                      
#                                                                          
# (c) 2006, 2007, 2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          
# To execute this spec run:                                            
#                                                                          
# spec spec/filehelper_spec.rb                                                  
#                                                                          


$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../../../lib')))

require 'rubygems'
require 'spec'
require 'dokkit'
require 'dokkit/resource/filenamehelper'
require 'spec/spec_helper.rb'

describe Dokkit::Resource::FilenameHelper do
  before do
    @resource = mock('resource')
    @resource.extend Dokkit::Resource::FilenameHelper
  end
  it 'should replace source path with the new path' do
    @resource.filename_helper('doc/pages/resource', 'doc/pages', 'output').should == 'output/resource'
  end
  it 'should add new extension to the source extension' do
    @resource.filename_helper('doc/pages/resource.ext', 'doc/pages', 'output', '.html').should == 'output/resource.ext.html'
  end
end

