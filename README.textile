dokkit
    by Andrea Fazzi
    http://dokkit.rubyforge.org

== DESCRIPTION:
  
dokkit is a document generator. It was inspired by rote but now it is
completely independent from it. dokkit uses filters like deplate and
maruku to generate output in a large variety of formats (tex, html,
docbook, plain text, ...).

With dokkit you can:

* generate static websites
* generate many types of documents in many formats (html, tex, plain text, etc.)
* write your documents using a simple wiki syntax and obtain high quality output
* generate different output formats from the same source document 
* use models to quickly generate the documents you want (technical report, invoice, howto, guides, presentation, website, etc.)
* simply derive new documentation models from the existing ones
* simply modify existing models to fit your needs

For more information please execute:

  dokkit --help

== FEATURES/PROBLEMS:
  
dokkit key features are:

* a smart building system based on rake[http://rake.rubyforge.org]
* a documentation directory structure organized in pages, layouts, configuration files, resources
* a templating system based on ERB
* a simple and flexible configuration system based on YAML
* support for partials

== SYNOPSIS:

To create a new documentation environment in <dirname> run:

  dokkit <dirname>

== REQUIREMENTS:

* deplate >= 0.8.0
* maruku => 0.5.9
* rake >= 0.8.1

== INSTALL:

  sudo gem install dokkit

== QUICK START

  $ dokkit mydocument
  $ cd mydocument
  $ rake

== LICENSE:

Copyright (c) 2008 Andrea Fazzi

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
