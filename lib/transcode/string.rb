# frozen_string_literal: true

# vi: et lbr sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2018-2026 David Rabkin
# SPDX-License-Identifier: 0BSD

# Adds a natural sort method. It converts a string such as "Filename 10"
# into an array with floats in place of numbers, ["Filename", 10.0], as
# suggested in https://stackoverflow.com/q/4078906.
class String
  def naturalized
    scan(/[^\d.]+|[\d.]+/).map { |f| f.match?(/\d+(\.\d+)?/) ? f.to_f : f }
  end
end
