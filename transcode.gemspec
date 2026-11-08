# frozen_string_literal: true

# SPDX-FileCopyrightText: 2023-2026 David Rabkin
# SPDX-License-Identifier: 0BSD

require_relative 'lib/transcode/version'

Gem::Specification.new do |s|
  s.required_ruby_version = '>= 3.2'
  s.name = 'transcode'
  s.version = Transcode::VERSION
  s.summary = 'Transcodes, inspects, and converts videos'
  s.description = <<-HERE
    Transcode is a command-line tool that transcodes, inspects, and converts
    videos. It runs Lisa Melton's Video Transcoding on every video in a
    directory.
  HERE
  s.license = '0BSD'
  s.author = 'David Rabkin'
  s.email = 'david@rabkin.co.il'
  s.homepage = 'https://rdavid.github.io/transcode'
  s.files = `git ls-files -z bin lib LICENSE README.adoc`.split("\x0")
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.extra_rdoc_files = ['LICENSE', 'README.adoc']
  repo = 'https://github.com/rdavid/transcode'
  s.metadata = {
    'bug_tracker_uri' => "#{repo}/issues",
    'homepage_uri' => s.homepage,
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => repo
  }
  s.add_dependency 'ellipsized', '~> 0.3'
  s.add_dependency 'terminal-table', '~> 4.0'
  s.add_dependency 'video_transcoding', '~> 0.25'
end
