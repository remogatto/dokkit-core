#                                                                          
# File 'base.rb' created on 15 ago 2008 at 22:34:26.                    
#
# See 'dokkit.rb' or +LICENSE+ for license information.                      
#                                                                          
# (C)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

require 'logger'
require 'rake/tasklib'

module Dokkit
  module TaskLib

    class Base < Rake::TaskLib
    
      attr_reader :ns
      attr_accessor :logger
    
      def initialize(ns)
        @ns = ns
        @logger ||= Logger.new(STDOUT)  
      end
      
      protected
      
      def define_tasks
        namespace @ns do
          private_methods.select { |meth| meth =~ /define_.+_task/ }.each { |meth| send meth }
        end
      end

    end
    
  end
end
