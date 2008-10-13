#                                                                          
# File 'url.rb' created on 09 mag 2008 at 19:13:53.                    
#
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (C)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

module Dokkit
  module Resource
    module Extension
      module Url
        def relative(href)
          thr = href
          if thr.is_a?(String) && href[0,1] == '/'     
            dtfn = File.dirname(source_fn[/^#{env_configuration[:document_dir]}\/(.*)/,1]) + '/'
            count = dtfn == './' ? 0 : dtfn.split('/').length
            thr = ('../' * count) + href[1..href.length]
          end        
          thr
        end      
      end
    end
  end
end
