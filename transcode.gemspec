# frozen_string_literal: true

# SPDX-FileCopyrightText: 2023-2025 David Rabkin
# SPDX-License-Identifier: 0BSD

$LOAD_PATH.unshift File.expand_path("#{File.dirname(__FILE__)}/lib")

require 'transcode'

Gem::Specification.new do |s|
  s.name = 'transcode'
  s.version = Transcode::VERSION
  s.date = Transcode::DATE
  s.required_ruby_version = '>2.6'
  s.summary = 'Tools to transcode batch of video files.'
  s.description = <<-HERE
    Transcode is a wrapper on Video Transcoding.
  HERE
  s.license = '0BSD'
  s.author = 'David Rabkin'
  s.email = 'david@rabkin.co.il'
  s.homepage = 'https://github.com/rdavid/transcode'
  s.files = Dir['{bin,lib}/**/*'] + Dir['[A-Z]*'] + ['transcode.gemspec']
  s.executables = ['transcode']
  s.extra_rdoc_files = ['LICENSE', 'README.md']
  s.require_paths = ['lib']
  s.add_runtime_dependency 'pidfile', '0.3.0'
  s.add_runtime_dependency 'terminal-table', '4.0.0'
  s.add_runtime_dependency 'video_transcoding', '0.25.3'
  s.add_development_dependency 'minitest', '5.25.4'
  s.add_development_dependency 'rake', '13.3.0'
  s.add_development_dependency 'rubocop', '1.50.2'
end
