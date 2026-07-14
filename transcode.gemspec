# frozen_string_literal: true

# SPDX-FileCopyrightText: 2023-2026 David Rabkin
# SPDX-License-Identifier: 0BSD

require_relative 'lib/transcode/version'

Gem::Specification.new do |s|
  s.required_ruby_version = '>= 3.2'
  s.name = 'transcode'
  s.version = Transcode::VERSION
  s.summary = 'Tool to transcode batches of video files'
  s.description = <<-HERE
    Transcode wraps Lisa Melton's Video Transcoding and converts whole
    directories of video files in one run.
  HERE
  s.license = '0BSD'
  s.author = 'David Rabkin'
  s.email = 'david@rabkin.co.il'
  s.homepage = 'https://github.com/rdavid/transcode'
  s.files = `git ls-files -z bin lib LICENSE README.adoc`.split("\x0")
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.extra_rdoc_files = ['LICENSE', 'README.adoc']
  s.metadata = {
    'bug_tracker_uri' => "#{s.homepage}/issues",
    'homepage_uri' => s.homepage,
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => s.homepage
  }
  s.add_dependency 'ellipsized', '~> 0.3'
  s.add_dependency 'terminal-table', '~> 4.0'
  s.add_dependency 'video_transcoding', '~> 0.25'
end
