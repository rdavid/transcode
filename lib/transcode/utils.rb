# frozen_string_literal: true

# vi: et lbr sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2018-2026 David Rabkin
# SPDX-License-Identifier: 0BSD

require 'ellipsized'

# Provides string helpers as class methods.
class Utils
  @sep = '~'
  class << self
    attr_accessor :sep

    def trim(src, lim)
      src.ellipsized(lim, @sep, :center)
    end
  end
end
