#                                                                          
# File 'logger.rb' created on 23 feb 2008 at 15:46:54.                    
#
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (C) 2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

#require 'dokkit'

module Dokkit
  module Logging

    # Define logger constants.
    OFF, ERROR, WARNING, INFO, DEBUG = (-1..3).to_a

    # Logger instance send log message to all its attached observers.
    class Logger

      attr_reader :observers
      attr_reader :last_message
      attr_reader :level

      def initialize
        @observers = []
        @level = INFO
      end

      # Set the logging level.
      def level=(new_level)
        new_level = DEBUG if new_level > DEBUG
        new_level = OFF if new_level < ERROR
        @level = new_level
      end

      # Attach an observer to the logger instance.
      def attach(observer)
        (@observers << observer).last
      end

      # Detach the observer from the logger instance.
      def detach(observer)
        @observers.delete(observer)
      end

      # Notify log messages to all attached observers.
      def notify
        @observers.each { |observer| observer.update }
      end

      def message(message)
        @last_message = message
        notify
        @last_message
      end

      # Send an info message to observers.
      def info(text)
        message({ :text => text, :level => INFO }) if level >= INFO
      end

      # Send an error message to the observers.
      def error(text)
        message({ :text => text, :level => ERROR }) if level >= ERROR
      end

      # Send a warning message to the observers.
      def warn(text)
        message({ :text => text, :level => WARNING }) if level >= WARNING
      end

      # Send a debug message to the observers.
      def debug(text)
        message({ :text => text, :level => DEBUG }) if level >= DEBUG
      end      

    end
  end
end
