# frozen_string_literal: true

# vi: et lbr sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2018-2026 David Rabkin
# SPDX-License-Identifier: 0BSD

# Measures elapsed time and reports it as a humanized string.
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

    DIC.filter_map do |cnt, nms, nm1|
      next if sec <= 0

      sec, n = sec.divmod(cnt)
      "#{n.to_i} #{n.to_i == 1 ? nm1 : nms}"
    end.compact.reverse.join(' ')
  end
end
