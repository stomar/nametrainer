# Rakefile for the nametrainer program.
#
# Copyright (C) 2012 Marcus Stollsteimer

require 'rake/testtask'

BINDIR = '/usr/local/bin'

BINARY = 'bin/nametrainer'


def gemspec_file
  'nametrainer.gemspec'
end


task :default => [:test]

Rake::TestTask.new do |t|
  t.pattern = 'test/**/test_*.rb'
  t.ruby_opts << '-rubygems'
  t.verbose = true
  t.warning = true
end


desc 'Build gem'
task :build do
  sh "gem build #{gemspec_file}"
end
