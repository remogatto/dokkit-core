#                                                                          
# File 'hash.rb' created on 17 mar 2008 at 09:37:25.                    
#
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (C) 2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

class Symbol
  def include_clear?
    nil
  end
  def delete_clear
    nil
  end
end

class String
  def include_clear?
    self == 'clear'
  end
  def delete_clear
    nil
  end
end

class Array
  def include_clear?
    include?('clear')
  end
  def delete_clear
    delete('clear')
    self
  end
end

class Hash
  # Hash#recursive_merge merges two arbitrarily deep hashes into a single hash. 
  # The hash is followed recursively, so that deeply nested hashes that are at 
  # the same level will be merged when the parent hashes are merged.
  def recursive_merge!(other_hash, &blk)
    if block_given?
      merge!(other_hash, &blk)
    else
      merge!(other_hash) do |key, value, other_value|
        recursive_store(key, value, other_value)
      end
    end
  end
  # Non-destructive version of Hash#recursive_merge method.
  def recursive_merge(other_hash, &blk)
    dup.recursive_merge!(other_hash, &blk)
  end
  
  private
  
  def merge_value(value, other_value, &blk)
    unless other_value.include_clear?
      yield value, other_value
    else
      value = other_value.delete_clear
    end
  end
  
  def recursive_store(key, value, other_value)
    if(value.class == Hash && other_value.class == Hash)
      value.recursive_merge other_value
    elsif(value.class == String && other_value.class == String)
      merge_value(value, other_value) { |v, ov| v = ov }
    elsif(value.class == Symbol && other_value.class == String)
      merge_value(value, other_value) { |v, ov| v = ov }
    elsif(value.class == Array && other_value.class == Array)
      merge_value(value, other_value) { |v, ov| v.concat ov }
    elsif(value.class == String && other_value.class == Array)
      merge_value(value, other_value) { |v, ov| v.to_a.concat ov }
    elsif(value.class == Array && other_value.class == String)
      merge_value(value, other_value) { value << other_value }
    else
      store(key, other_value)
    end
  end  
end
