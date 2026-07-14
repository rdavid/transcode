# frozen_string_literal: true

# vi: et lbr sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2020-2026 David Rabkin
# SPDX-License-Identifier: 0BSD

require 'minitest/autorun'
require_relative '../lib/transcode/string'
require_relative '../lib/transcode/timer'
require_relative '../lib/transcode/utils'

class TestUtils < Minitest::Test
  def setup
    @tim = Timer.new
  end

  def test_timer_read
    assert_equal(Timer.less_sec, @tim.read)
  end

  def test_humanize_boundaries
    assert_empty(@tim.humanize(nil))
    assert_equal(Timer.less_sec, @tim.humanize(0.5))
  end

  def test_humanize_intervals
    assert_equal('1 second', @tim.humanize(1))
    assert_equal('2 seconds', @tim.humanize(2))
    assert_equal('1 minute 1 second', @tim.humanize(61))
    assert_equal('1 hour 1 minute 1 second', @tim.humanize(3661))
  end

  def test_naturalized
    assert_equal(['Filename ', 10.0], 'Filename 10'.naturalized)
    assert_equal(%w[a2 a10], %w[a10 a2].sort_by(&:naturalized))
  end

  def test_trim
    s = Utils.sep

    assert_equal("ni#{s}bo", Utils.trim('ninesymbo', 5))
    assert_equal("te#{s}ls", Utils.trim('tensymbols', 5))
    assert_equal("nin#{s}bo", Utils.trim('ninesymbo', 6))
    assert_equal("ten#{s}ls", Utils.trim('tensymbols', 6))
  end

  def test_trim_short_input
    assert_equal('short', Utils.trim('short', 10))
  end
end
