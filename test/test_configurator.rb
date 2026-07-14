# frozen_string_literal: true

# vi: et lbr sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2026 David Rabkin
# SPDX-License-Identifier: 0BSD

require 'minitest/autorun'
require 'tmpdir'
require_relative '../lib/transcode/configurator'

class TestConfigurator < Minitest::Test
  def setup
    @argv = ARGV.dup
  end

  def teardown
    ARGV.replace(@argv)
  end

  def configure(dir, *args)
    ARGV.replace(['-d', dir, '-w', '79'] + args)
    Transcode::Configurator.new
  end

  def touch(dir, *names)
    names.each { |name| File.write(File.join(dir, name), '') }
  end

  def test_finds_files
    Dir.mktmpdir do |dir|
      touch(dir, 'a.mkv', 'b.mp4')
      cfg = configure(dir)

      assert_equal(%w[a.mkv b.mp4], cfg.files.map { |f| File.basename(f) })
    end
  end

  def test_sorts_files_naturally
    Dir.mktmpdir do |dir|
      touch(dir, 'b10.mkv', 'b2.mkv')
      cfg = configure(dir)

      assert_equal(%w[b2.mkv b10.mkv], cfg.files.map { |f| File.basename(f) })
    end
  end

  def test_rejects_empty_dir
    Dir.mktmpdir do |dir|
      err = assert_raises(RuntimeError) { configure(dir) }

      assert_match(/has no/, err.message)
    end
  end

  def test_expands_single_stream_value
    Dir.mktmpdir do |dir|
      touch(dir, 'a.mkv', 'b.mkv')
      cfg = configure(dir, '-u', '3')

      assert_equal(%w[3 3], cfg.aud)
    end
  end

  def test_rejects_mismatched_stream_count
    Dir.mktmpdir do |dir|
      touch(dir, 'a.mkv', 'b.mkv')
      err = assert_raises(RuntimeError) { configure(dir, '-u', '1,2,3') }

      assert_match(/count 3 doesn't match file count 2/, err.message)
    end
  end

  def test_rejects_narrow_table
    Dir.mktmpdir do |dir|
      touch(dir, 'a.mkv')
      ARGV.replace(['-d', dir, '-w', '10'])
      err = assert_raises(RuntimeError) { Transcode::Configurator.new }

      assert_match(/must exceed 14/, err.message)
    end
  end

  def test_fills_default_titles
    Dir.mktmpdir do |dir|
      touch(dir, 'a.mkv')
      cfg = configure(dir)

      assert_equal(%w[0], cfg.tit)
    end
  end
end
