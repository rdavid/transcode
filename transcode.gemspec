# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'transcode'

Gem::Specification.new do |s|
  s.name = 'transcode'
  s.version = Transcode::VERSION
  s.required_ruby_version = '>= 2.2'
  s.summary = 'Tools to transcode batch of video files.'
  s.description = <<-HERE
    Transcode is a wraper on Video Transcoding.
  HERE
  s.license = 'BSD-2-Clause'
  s.author = 'David Rabkin'
  s.email = 'pub@rabkin.co.il'
  s.homepage = 'https://github.com/rdavid/transcode'
  s.files = Dir['{bin,lib}/**/*'] + Dir['[A-Z]*'] + ['transcode.gemspec']
  s.executables = ['transcode']
  s.extra_rdoc_files = ['LICENSE', 'README.md']
  s.require_paths = ['lib']
end
