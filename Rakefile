# frozen_string_literal: true

# vi: et lbr sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2020-2026 David Rabkin
# SPDX-License-Identifier: 0BSD

require 'rake/testtask'

task default: %w[test]

desc 'Run the test suite'
Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/test_*.rb'
end
