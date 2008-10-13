# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

load 'tasks/setup.rb'

ensure_in_path 'lib'
require 'dokkit'

task :default => 'spec:run'

PROJ.name = 'dokkit'
PROJ.version = Dokkit::VERSION
PROJ.summary = 'dokkit is an open source document generator'
PROJ.authors = 'Andrea Fazzi'
PROJ.email = 'andrea.fazzi@alca.le.it'
PROJ.url = 'http://dokkit.rubyforge.org'
PROJ.description = paragraphs_of('README.txt', 1).join("\n\n")
PROJ.changes = paragraphs_of('History.txt', 0..1).join("\n\n")
PROJ.rubyforge_name = 'dokkit'
PROJ.dependencies = ['deplate', 'rake', 'maruku']
PROJ.need_zip = true
PROJ.spec_opts << ['--format', 'specdoc', '--color']
PROJ.rdoc_exclude << "models/simple"
# EOF
