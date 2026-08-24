# frozen_string_literal: true

# vi: et lbr sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2026 David Rabkin
# SPDX-License-Identifier: 0BSD

require 'minitest/autorun'
require 'shellwords'
require 'tmpdir'
require_relative '../lib/transcode'

class TestTranscoder < Minitest::Test
  def setup
    @argv = ARGV.dup
  end

  def teardown
    ARGV.replace(@argv)
  end

  def transcoder(dir)
    File.write(File.join(dir, 'a.mkv'), '')
    ARGV.replace(['-d', dir, '-o', dir, '-w', '79'])
    Transcode::Transcoder.new
  end

  def test_mp3_cmd
    Dir.mktmpdir do |dir|
      cmd = transcoder(dir).mp3_cmd(File.join(dir, 'a.mkv'))

      assert_match(/^ffmpeg -nostdin -i .*a\.mkv .*-f mp3 .*a\.mp3$/, cmd)
      assert_includes(cmd, '-q:a 0')
      refute_includes(cmd, '-ar')
      refute_includes(cmd, '-ab')
    end
  end

  def test_mp3_files_skips_existing_destination
    Dir.mktmpdir do |dir|
      t = transcoder(dir)
      File.write(File.join(dir, 'a.mp3'), '')
      files = nil
      _, err = capture_io { files = t.mp3_files }

      assert_empty(files)
      assert_match(/Skip: .*a\.mkv exists as .*a\.mp3/, err)
    end
  end

  def test_mp3_files_includes_missing_destination
    Dir.mktmpdir do |dir|
      t = transcoder(dir)

      assert_equal([File.join(dir, 'a.mkv')], t.mp3_files)
    end
  end

  def test_scn_cmd
    Dir.mktmpdir do |dir|
      file = File.join(dir, 'a.mkv')

      assert_equal(
        "transcode-video --scan #{file.shellescape}",
        transcoder(dir).scn_cmd(file)
      )
    end
  end

  def test_m4v_cmd_with_streams
    Dir.mktmpdir do |dir|
      cmd = transcoder(dir).m4v_cmd(File.join(dir, 'a.mkv'), '1', '2', '0')

      assert_includes(cmd, '--main-audio 1')
      assert_includes(cmd, '--burn-subtitle 2')
      refute_includes(cmd, '--title')
    end
  end

  def test_m4v_cmd_with_title
    Dir.mktmpdir do |dir|
      cmd = transcoder(dir).m4v_cmd(File.join(dir, 'a.mkv'), '0', '0', '5')

      assert_includes(cmd, '--title 5')
      refute_includes(cmd, '--main-audio')
    end
  end
end
