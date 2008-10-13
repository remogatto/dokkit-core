#                                                                          
# File 'extmap_spec.rb' created on 14 mag 2008 at 10:51:19.                    
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (c)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../../../../lib')))

require 'rubygems'
require 'spec'
require 'dokkit/environment/helpers/extmap'
require 'spec/spec_helper.rb'


module Dokkit
  module Resource
    module Extension
      
    end
  end
  module Environment
    module Helper
      describe ExtMap do
        include SpecHelper::Path
        before(:all) do
          @initial_dir = Dir.pwd
          Dir.chdir(File.join(File.dirname(__FILE__), SpecHelper::Path::TEST_DATA))
        end
        after(:all) do
          Dir.chdir(@initial_dir)
        end
        before do
          @extension_block = lambda { |document| document.extend Extension }
          @extmap = ExtMap.new('doc/pages').include('*.ext*').map(&@extension_block)
        end
        it 'should return the correct filelist array' do
          @extmap.files.sort.should == [document_path('document_1.ext_1'), document_path('document_3.ext_3')]
        end
        it 'should map the extension block to document_1.ext_1' do
          @extmap['doc/pages/document_1.ext_1'].should == @extension_block
        end
        it 'should map the extension block to document_1.ext_1' do
          @extmap['doc/pages/document_3.ext_3'].should == @extension_block
        end
      end
    end
  end
end



