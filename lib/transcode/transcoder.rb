# frozen_string_literal: true

# vi:ts=2 sw=2 tw=79 et lbr wrap
# Copyright 2018-2023 by David Rabkin

require 'English'
require 'shellwords'
require_relative 'configurator'
require_relative 'reporter'

module Transcode
  # Transcodes any video file to m4v format.
  class Transcoder
    def initialize
      @cfg = Configurator.new
      @rep = Reporter.new(@cfg.act?, "#{@cfg.dir} -> #{@cfg.out}", @cfg.wid)
    end

    # Runs command and prints output instantly. Returns true on success.
    def run(cmd)
      cmd += ' 2>&1'
      puts "Run: #{cmd}."
      IO.popen(cmd).each do |line|
        puts line.chomp
      end.close
      $CHILD_STATUS.success?
    end

    def m4v_cmd(file, aud, sub, tit)
      c = 'transcode-video --m4v --no-log --preset veryslow'\
          " --output #{@cfg.out}"
      unless tit == '0'
        c += "/#{File.basename(file.shellescape)}-#{tit}.m4v"
        c += " --title #{tit}"
      end
      c += " --main-audio #{aud}" unless aud == '0'
      c += " --burn-subtitle #{sub}" unless sub == '0'
      c + " #{file.shellescape}"
    end

    # Converts files, audibale, subtitles and titles arrays to array:
    #   [ file1 [ aud1, sub1, tit1 ] ]
    #   [ file2 [ aud2, sub2, tit2 ] ]
    def data
      @data ||= @cfg.files.zip([@cfg.aud, @cfg.sub, @cfg.tit].transpose)
    end

    def m4v
      data.each do |f, as|
        res = @cfg.act? ? run(m4v_cmd(f, as[0], as[1], as[2])) : true
        @rep.add(f, res, as[0], as[1], as[2])
      end
    end

    def mp3_cmd(file)
      file = file.shellescape
      "ffmpeg -i #{file} -vn -ar 44100 -ac 2 -ab 192k -f mp3 "\
        "#{@cfg.out}/#{File.basename(file, '.*')}.mp3"
    end

    def scn_cmd(file)
      "transcode-video --scan #{file.shellescape}"
    end

    def do # rubocop:disable Metrics/AbcSize
      if @cfg.mp3?
        @cfg.files.each { |f| @rep.add(f, @cfg.act? ? run(mp3_cmd(f)) : true) }
      elsif @cfg.sca?
        @cfg.files.each { |f| @rep.add(f, run(scn_cmd(f))) }
      else
        m4v
      end
      @rep.do
    end
  end
end
