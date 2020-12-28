# frozen_string_literal: true

# vi:ts=2 sw=2 tw=79 et lbr wrap
# Copyright 2020 by David Rabkin

require 'minitest/autorun'
require_relative '../lib/transcode/utils'

class TestUtils < Minitest::Test
  def setup
    @tim = Timer.new
  end

  def test_timer
    assert_equal(Timer.less_sec, @tim.read)
    sleep(1)
    assert_equal('1 second', @tim.read)
    sleep(1)
    assert_equal('2 seconds', @tim.read)
  end

  def test_trim
    s = Utils.sep
    assert_equal("ni#{s}bo", Utils.trim('ninesymbo', 5))
    assert_equal("te#{s}ls", Utils.trim('tensymbols', 5))
    assert_equal("nin#{s}bo", Utils.trim('ninesymbo', 6))
    assert_equal("ten#{s}ls", Utils.trim('tensymbols', 6))
  end
end
