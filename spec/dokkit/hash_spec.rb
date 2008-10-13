#                                                                          
# File 'recursivemerge_spec.rb' created on 09 feb 2008 at 19:08:20.                    
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (c)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../../lib')))

require 'rubygems'
require 'spec'
require 'dokkit/hash'

describe Hash do
  describe 'when two hash with depth 0 are merged' do
    before do
      @h1 = { :a => "a", :b => "b" }
      @h2 = { :c => "c" }
    end
    it 'should return a new hash with :a, :b, :c keys' do
      @h1.recursive_merge(@h2).should == { :a => "a", :b => "b", :c => "c"}
    end
  end
  describe 'when two hash with depth 1 are merged' do
    before do
      @h1 = { :depth1 => { :a => "a", :b => "b" }, :b => "b" }
      @h2 = { :depth1 => { :a => "a'", :c => "c" }, :b => "b'" }
    end
    it 'should return a new hash merging depth 1 values,' do
      @h1.recursive_merge(@h2).should == { :depth1 => { :a => "a'", :b => "b", :c => "c"}, :b => "b'" }
    end
  end
  describe 'when two hash with depth 2 and depth 1 are merged' do
    before do
      @h1 = { :depth1 => { :depth2 => { :a => "a", :b => "b" } }, :b => "b" }
      @h2 = { :depth1 => { :a => "a'", :b => "b'", :c => "c"}, :b => "b" }
    end
    it 'should return a new hash merging the depth 1 values adding the depth 2 key' do
      @h1.recursive_merge(@h2).should == { :depth1 => {:depth2 => { :a => "a", :b => "b" }, :a => "a'", :b => "b'", :c => "c"}, :b => "b" }
    end
  end
  describe 'when a block is passed to recursive_merge' do
    it 'should use the block to store values' do
      { :a => 'a' }.recursive_merge({ :a => ['b', 'c'] }) do |key, value, other_value|
        if(value.class == String && other_value.class == Array)
          value.to_a.concat(other_value)
        else
         store(key, other_value)
        end
      end.should == { :a => ['a', 'b', 'c'] }
    end
  end
  describe 'when a string and an array are merged' do
    before do
      @h1 = { :a => 'a' }
      @h2 = { :a => ['b', 'c'] }
    end
    it 'should concatenate the string and the array' do
      @h1.recursive_merge(@h2).should == { :a => ['a', 'b', 'c'] }
      @h2.recursive_merge(@h1).should == { :a => ['b', 'c', 'a'] }      
    end
  end
  describe 'when two array are merged' do
    before do
      @h1 = { :a => { :b => ['a', 'b'] } }
      @h2 = { :a => { :b => ['c', 'd'] } }
    end
    it 'should concatenate the arrays' do
      @h1.recursive_merge(@h2).should == { :a => { :b => ['a', 'b', 'c', 'd'] } }
    end
  end
  describe 'when a :clear key is encountered' do
    it 'should stop merging string and string' do
      { :a => 'a', :b => 'b' }.recursive_merge({ :a => 'clear', :c => 'c' }).should == { :a => nil, :b => 'b', :c => 'c' }
    end
    it 'should stop merging symbol and string' do
      { :a => :a, :b => 'b' }.recursive_merge({ :a => 'clear', :c => 'c' }).should == { :a => nil, :b => 'b', :c => 'c' }
    end
    it 'should stop merging arrays' do
      { :a => ['a', 'b'], :b => 'b' }.recursive_merge({ :a => ['a', 'clear'], :c => 'c' }).should == { :a => ['a'], :b => 'b', :c => 'c' }
    end
    it 'should stop merging array and string' do
      { :a => ['a', 'b'], :b => 'b' }.recursive_merge({ :a => 'clear', :c => 'c' }).should == { :a => nil, :b => 'b', :c => 'c' }
    end
    it 'should stop merging string and array' do
      { :a => 'a', :b => 'b' }.recursive_merge({ :a => ['clear', 'b'], :c => 'c' }).should == { :a => ['b'], :b => 'b', :c => 'c' }
    end
  end
end
