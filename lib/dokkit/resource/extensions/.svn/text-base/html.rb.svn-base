#                                                                          
# File 'html.rb' created on 21 giu 2008 at 19:55:48.                    
#
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (C)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

require 'dokkit/resource/extensions/url'

module Dokkit
  module Resource
    module Extension
      module HTML
        include Url
        def link_to(name, args = { })
          "<a href=\"#{relative(args[:href])}\" class=\"#{args[:class]}\">#{name}</a>"
        end
      end
    end
  end
end
