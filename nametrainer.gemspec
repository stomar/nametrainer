require './lib/nametrainer/version'

version  = Nametrainer::VERSION
date     = Nametrainer::DATE
homepage = Nametrainer::HOMEPAGE

Gem::Specification.new do |s|
  s.name              = 'nametrainer'
  s.version           = version
  s.date              = date

  s.summary = 'nametrainer is a name learning trainer using the Qt GUI toolkit.'
  s.description = s.summary + ' ' +
              "It will assist you in learning people's names from a collection of images."

  s.authors = ['Marcus Stollsteimer']
  s.email = 'sto.mar@web.de'
  s.homepage = homepage

  s.license = 'GPL-3.0'

  s.requirements << 'the Qt toolkit and Qt bindings for Ruby'

  # s.add_dependency('iconv')  # only for 1.8; problematic on Windows (build tools necessary)
  s.add_development_dependency('rake')
  s.add_development_dependency('minitest')

  s.executables = ['nametrainer']
  s.bindir = 'bin'

  s.require_paths = ['lib']

  s.test_files = Dir.glob('test/**/test_*.rb')

  s.files = %w{
      README.md
      Rakefile
      nametrainer.gemspec
      screenshot.png
    } +
    Dir.glob('{bin,demo_collection,lib,test}/**/*')

  s.rdoc_options = ['--charset=UTF-8']
end
