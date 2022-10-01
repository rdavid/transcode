# frozen_string_literal: true

# vi:ts=2 sw=2 tw=79 et lbr wrap
# Copyright 2018-2020 by David Rabkin

require 'terminal-table'
require_relative 'utils'

module Transcode
  # Formats and prints output data.
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

    def do
      msg = "#{@act ? 'Real' : 'Test'}:#{stat} in #{@tim.read}."
      msg = Utils.trim(msg, @ttl)
      puts "#{table}\n| #{msg}#{' ' * (@ttl - msg.length)} |\n+-#{'-' * @ttl}-+"
    end

    def stat
      out = ''
      @sta.each do |k, v|
        out += ' ' + v.to_s + ' ' + k.to_s + ',' if v.positive?
      end
      out.chop
    end
  end
end
