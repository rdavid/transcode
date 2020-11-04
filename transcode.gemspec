# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'transcode'

Gem::Specification.new do |s|
  s.name = 'transcode'
  s.version = Transcode::VERSION
  s.date = Transcode::DATE
  s.required_ruby_version = '~> 2.6'
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
  s.extra_rdoc_files = ['LICENSE.txt', 'README.md']
  s.require_paths = ['lib']
  s.add_runtime_dependency 'pidfile', '0.3.0'
  s.add_runtime_dependency 'terminal-table', '1.8.0'
  s.add_runtime_dependency 'video_transcoding', '0.25.3'
  s.add_development_dependency 'minitest', '5.11.3'
  s.add_development_dependency 'rake', '13.0.1'
  s.add_development_dependency 'rubocop', '0.76.0'
end
