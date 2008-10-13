#
# File 'fileselect_spec.rb' created on 07 feb 2008 at 15:46:04.
# See 'dokkit.rb' or +LICENSE+ for licence information.
#
# (c) 2006, 2007, 2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors).
#
# To execute this spec run:
#
# spec spec/fileselect_spec.rb
#


$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../../../../lib')))

require 'rubygems'
require 'spec'
require 'dokkit/environment/helpers/fileselection'
require 'spec/spec_helper.rb'

module Dokkit
  module Environment
    module Helper
      describe FileSelection, ' when initialized' do
        include SpecHelper::Path
        before(:all) do
          @initial_dir = Dir.pwd
          Dir.chdir(File.expand_path(File.join(File.dirname(__FILE__), '..', SpecHelper::Path::TEST_DATA)))
        end
        after(:all) do
          Dir.chdir(@initial_dir)
        end
        it 'should set the current dir as default base path' do
          fs = FileSelection.new
          fs.base_dir.should == '.'
        end
        it 'should set the given directory as the base path for all operations' do
          fs = FileSelection.new(document_path)
          fs.base_dir.should == document_path
        end
      end
      describe FileSelection, '#files' do
        include SpecHelper::Path
        before(:all) do
          @initial_dir = Dir.pwd
          Dir.chdir(File.expand_path(File.join(File.dirname(__FILE__), '..', SpecHelper::Path::TEST_DATA)))
        end
        after(:all) do
          Dir.chdir(@initial_dir)
        end
        it 'should return an array with the list of the included files in the given directory' do
          FileSelection.new(document_path) do |fs|
            fs.include('*')
          end.files.should have(3).items
        end
        it 'should not include files that was explicity excluded' do
          FileSelection.new(document_path) do |fs|
            fs.exclude('*.exclude')
          end.files.should_not include(document_path('document_5.exclude'))
        end
        it 'should include only the files that was explicity included' do
          FileSelection.new(document_path) do |fs|
            fs.include('*_1')
          end.files.should include(document_path('document_1'))
        end
        it 'should not include the same files' do
          FileSelection.new(document_path) do |fs|
            fs.include('*')
            fs.include('*')
          end.files.should have(3).items
        end
        it 'should not include directory' do
          FileSelection.new(document_path) do |fs|
            fs.include('**/*')
          end.files.should_not include(document_path('subdir'))
        end
      end
    end
  end
end

