#                                                                          
# File 'url_spec.rb' created on 09 mag 2008 at 19:17:03.                    
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (c)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../../../../lib')))

require 'rubygems'
require 'spec'
require 'dokkit'
require 'dokkit/resource/extensions/url'
require 'spec/spec_helper.rb'

describe Dokkit::Resource::Extension::Url do
  before do
    @document = mock('document', 
                     :env_configuration => { :document_dir => 'doc/pages' },
                     :source_fn => 'doc/pages/subdir/document.ext'
                     )
    @document.extend Dokkit::Resource::Extension::Url
  end
   it 'should resolve the absolute path name' do
    @document.relative('/images/image.img').should == '../images/image.img'
  end
end


