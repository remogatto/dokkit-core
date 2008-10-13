#                                                                          
# File 'html_spec.rb' created on 21 giu 2008 at 19:57:13.                    
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (c)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

require 'rubygems'
require 'spec'
require 'dokkit'

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../../../../lib')))
require 'dokkit/resource/extensions/html'


module Dokkit
  module Resource
    module Extension
      
      describe HTML, '#link_to' do
        before do
          @document = mock('document', 
                           :env_configuration => { :document_dir => 'doc/pages' },
                           :source_fn => 'doc/pages/subdir/document.ext'
                           )
          @document.extend Dokkit::Resource::Extension::HTML
        end
        it 'should produce a link with the given href, name and class' do
          @document.link_to("Link to page", :href => '/page.html', :class => 'class').should == "<a href=\"../page.html\" class=\"class\">Link to page</a>"
        end
      end
      
    end
  end
end
