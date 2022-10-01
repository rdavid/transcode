# frozen_string_literal: true

# vi:ts=2 sw=2 tw=79 et lbr wrap
# Copyright 2018-2020 by David Rabkin

# All methods are static.
class Utils
  @sep = '~'
  class << self
    attr_accessor :sep
    def trim(src, lim)
      return '' if src.nil? || lim.nil?
      return src if src.length <= lim

      beg = fin = (lim - @sep.length) / 2
      beg -= 1 if lim.odd?
      src[0..beg] + @sep + src[-fin..-1]
    end
  end
end

# Returns string with humanized time interval.
class Timer
  @less_sec = 'less than a second'
  class << self
    attr_reader :less_sec
  end

  DIC = [
    [60,   :seconds, :second],
    [60,   :minutes, :minute],
    [24,   :hours,   :hour],
    [1000, :days,    :day]
  ].freeze

  def initialize
    @sta = Time.now
  end

  def read
    humanize(Time.now - @sta)
  end

  def humanize(sec)
    return '' if sec.nil?
    return Timer.less_sec if sec < 1

    DIC.map do |cnt, nms, nm1|
      next if sec <= 0

      sec, n = sec.divmod(cnt)
      "#{n.to_i} #{n.to_i != 1 ? nms : nm1}"
    end.compact.reverse.join(' ')
  end
end

# Adds natural sort method. This converts something like "Filename 10" into a
# simple array with floats in place of numbers [ "Filename", 10.0 ]. See:
#   https://stackoverflow.com/questions/4078906/is-there-a-natural-sort-by-method-for-ruby
class String
  def naturalized
    scan(/[^\d\.]+|[\d\.]+/).collect { |f| f.match(/\d+(\.\d+)?/) ? f.to_f : f }
  end
end
