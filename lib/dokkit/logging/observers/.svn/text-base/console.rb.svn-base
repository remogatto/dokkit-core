#                                                                          
# File 'consolelog.rb' created on 23 feb 2008 at 16:39:59.                    
#
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (C)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

require 'dokkit/logging/logger'

module Dokkit
  module Logging
    module Observer

      class Console
        
        class << self
          def logger
            Console.new(Logger.new).logger
          end
        end
        
        attr_reader :logger

        def initialize(logger)
          @logger = logger
          @logger.attach(self)
        end

        def update
          case last_message[:level]
          when Logging::ERROR
            fail "[#{Time.now.asctime}][ERROR] #{last_message[:text]}"
          when Logging::WARNING
            warn "[#{Time.now.asctime}][WARNING] #{last_message[:text]}"
          when Logging::INFO
            puts "[#{Time.now.asctime}][INFO] #{last_message[:text]}"
          when Logging::DEBUG
            puts "[#{Time.now.asctime}][DEBUG] #{last_message[:text]}"
          end
        end

        private
        
        def last_message
          @logger.last_message
        end
        
      end
    end
  end
end
