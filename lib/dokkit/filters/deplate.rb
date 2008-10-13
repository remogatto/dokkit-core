#--
# Dokkit filter for Deplate
# (c) 2006, 2007, 2008 Andrea Fazzi (and contributors)
#
# See 'dokkit.rb' or LICENSE for licence information.

require 'deplate/deplate-string'
require 'deplate/fmt/latex'

class Deplate::Formatter::LaTeX
  def initialize_deplate_sty; end
end

module Dokkit
  module Filter

    class DeplateHTML

      def filter(text)
        DeplateString.new(text).to_html
      end      

    end    

    class DeplateLatex

      def filter(text)
        DeplateString.new(text).to_latex
      end      

    end        

    class DeplateText

      def filter(text)
        DeplateString.new(text).to_text
      end      

    end            

  end
end


