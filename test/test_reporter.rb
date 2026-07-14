# frozen_string_literal: true

# vi: et lbr sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2026 David Rabkin
# SPDX-License-Identifier: 0BSD

require 'minitest/autorun'
require_relative '../lib/transcode/reporter'

class TestReporter < Minitest::Test
  def setup
    @rep = Transcode::Reporter.new(false, 'title', 79)
  end

  def test_stat_counts_results
    @rep.add('one.mkv', true)
    @rep.add('two.mkv', false)

    assert_equal(' 1 converted, 1 failed', @rep.stat)
  end

  def test_head_with_streams
    @rep.add('one.mkv', true, 1, 2, 3)

    assert_equal(4, @rep.head.size)
  end

  def test_head_without_streams
    @rep.add('one.mkv', true)

    assert_equal(1, @rep.head.size)
  end

  def test_do_prints_summary
    @rep.add('one.mkv', true)

    assert_output(/Test: 1 converted in less than a second/) { @rep.do }
  end
end
