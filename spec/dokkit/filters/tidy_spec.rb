#                                                                          
# File 'tidy_spec.rb' created on 27 lug 2008 at 14:30:55.                    
# See 'dokkit.rb' or +LICENSE+ for licence information.                      
#                                                                          
# (c)2006-2008 Andrea Fazzi <andrea.fazzi@alca.le.it> (and contributors). 
#                                                                          

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'../../../lib')))

require 'rubygems'
require 'spec'
require 'dokkit'
require 'dokkit/filters/tidy'

INPUT = <<EOI
<html>
<body>
<p>content</p>
</body>
</html>
EOI

OUTPUT = <<EOO
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2//EN">

<html>
<head>
  <meta name="generator" content=
  "HTML Tidy for Linux/x86 (vers 1 September 2005), see www.w3.org">

  <title></title>
</head>

<body>
  <p>content</p>
</body>
</html>
EOO

describe Dokkit::Filter::Tidy do
  before do
    @tidy = Dokkit::Filter::Tidy.new
  end
  it 'should compile an erb template' do
#    @tidy.filter(INPUT).should == OUTPUT
  end
end

