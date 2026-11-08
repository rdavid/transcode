# frozen_string_literal: true

# vi: et lbr sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2018-2026 David Rabkin
# SPDX-License-Identifier: 0BSD

require 'terminal-table'
require_relative 'timer'
require_relative 'utils'

module Transcode
  # Formats and prints the summary table.
  class Reporter
    def initialize(act, tit, wid)
      @act = act
      @tit = tit
      @tbl = wid
      @ttl = @tbl - 4
      @str = (@tbl - 7) / 2
      @row = []
      @tim = Timer.new
      @sta = { converted: 0, failed: 0 }
    end

    # Adds a table row for a file and counts its result. The track columns
    # appear only when an audio or subtitle value is set.
    def add(file, res, aud = 0, sub = 0, tit = 0)
      row = [Utils.trim(File.basename(file), @str)]
      if aud != 0 || sub != 0
        (row << [
          { value: aud, alignment: :right },
          { value: sub, alignment: :right },
          { value: tit, alignment: :right }
        ]).flatten!
      end
      @row << row
      @sta[res ? :converted : :failed] += 1
    end

    # Returns the column headings that match the rows.
    def head
      head = [{ value: 'file', alignment: :center }]
      if @row.first.size == 4
        (head << [
          { value: 'audio', alignment: :center },
          { value: 'subtitles', alignment: :center },
          { value: 'titles', alignment: :center }
        ]).flatten!
      end
      head
    end

    def table
      Terminal::Table.new(
        title: Utils.trim(@tit, @ttl),
        headings: head,
        rows: @row,
        style: { width: @tbl }
      )
    end

    # Prints the table with a footer that sums up the run and its time.
    def do
      msg = "#{@act ? 'Real' : 'Test'}:#{stat} in #{@tim.read}."
      msg = Utils.trim(msg, @ttl)
      puts "#{table}\n| #{msg}#{' ' * (@ttl - msg.length)} |\n+-#{'-' * @ttl}-+"
    end

    # Returns the nonzero result counts, such as ' 2 converted, 1 failed'.
    def stat
      out = ''
      @sta.each do |k, v|
        out += " #{v} #{k}," if v.positive?
      end
      out.chop
    end
  end
end
