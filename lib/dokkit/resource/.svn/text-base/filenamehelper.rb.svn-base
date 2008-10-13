#                                                                          
# File 'filenamehelper.rb' created on 21 apr 2008 at 14:25:47.                    
#
# See 'dokkit.rb' or +LICENSE+ for license information.                      
#                                                                          
# (C) 2006, 2007, 2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

module Dokkit
  module Resource
    
    # This is a helper module that aims to simplify operation with
    # filenames.
    module FilenameHelper
    
      # Return a filename transformed in its directory part and
      # (optionally) in its extension.
      # +fn+:: is the source filename.
      # +dir+:: is the directory part to be changed.
      # +new_dir+:: is the new directory part that substitutes +dir+.
      # +new_ext+:: is the (optionally) new extension for the +fn+.
      def filename_helper(fn, dir, new_dir, new_ext = '')
        ext = File.extname(fn).sub(/^\./,'') # strip leading dot
        new_fn = fn.sub(/#{dir}/, new_dir)
        new_fn = new_fn << new_ext unless new_ext.empty?
        new_fn
      end    
    
    end
    
  end
end
