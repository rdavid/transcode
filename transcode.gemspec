# frozen_string_literal: true

# SPDX-FileCopyrightText: 2023-2026 David Rabkin
# SPDX-License-Identifier: 0BSD

$LOAD_PATH.unshift File.expand_path("#{File.dirname(__FILE__)}/lib")

require 'transcode'

Gem::Specification.new do |s|
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.required_ruby_version = '>=3.2'
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
  s.files = `git ls-files | grep -E -v '^(test/|\\.)'`.split($RS)
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.extra_rdoc_files = ['LICENSE', 'README.adoc']
  s.metadata['rubygems_mfa_required'] = 'true'
end
