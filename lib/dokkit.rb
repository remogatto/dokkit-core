# dokkit.rb - main Dokkit module  

#####
## *Dokkit* is a rake (http://rake.rubyforge.org) based documentation
## building tool. It uses filters to produce very polished tex file,
## page-based documentation, websites, and general textual templates.
## It enables embedded ruby code, layouts, YAML config files and rake
## tasks to be used to automatically generate output in any (textual)
## format from a directory tree containing template files.
##
## Dokkit was created to manage the documentation produced by Alca
## Coop (http://alca.le.it/) for its customers and it is a fairly
## flexible tool.
##
## Dokkit can be used from the command-line, or in your own
## +Rakefile+. It supports both manual and automatic rendering of
## modified resources.
##
## See +README+ and http://dokkit.rubyforge.org for general usage
## information.
##
## Copyright (C) 2006, 2007, 2008  Andrea Fazzi (and contributors).
##
## This program is free software: you can redistribute it and/or
## modify it under the terms of the GNU General Public License as
## published by the Free Software Foundation, either version 3 of the
## License, or (at your option) any later version.
##
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see
## <http://www.gnu.org/licenses/>.
##
## See +LICENSE+ for details.

# require these before gems, because we want to use them from
# lib/ , or from normal install, if that's how Dokkit was started.
# 
# If Dokkit has been loaded through Gems, this will automatically
# come from the right lib directory...

# Everything else should come first from Gems, if installed.
begin
  require 'rubygems'
rescue LoadError
  nil   # just try without then...
end  

module Dokkit
  VERSION = '0.5.0'
end 
