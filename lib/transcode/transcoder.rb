# frozen_string_literal: true

# vi: et lbr sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2018-2026 David Rabkin
# SPDX-License-Identifier: 0BSD

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

    # Runs a command and prints its output as it arrives. Returns true on
    # success.
    def run(cmd)
      cmd += ' 2>&1'
      puts "Run: #{cmd}."
      IO.popen(cmd).each do |line|
        puts line.chomp
      end.close
      $CHILD_STATUS.success?
    end

    def m4v_cmd(file, aud, sub, tit)
      c = 'transcode-video --m4v --no-log --preset veryslow ' \
          "--output #{@cfg.out}"
      unless tit == '0'
        c += "/#{File.basename(file.shellescape)}-#{tit}.m4v"
        c += " --title #{tit}"
      end
      c += " --main-audio #{aud}" unless aud == '0'
      c += " --burn-subtitle #{sub}" unless sub == '0'
      c + " #{file.shellescape}"
    end

    # Converts file, audio, subtitle, and title arrays into an array of
    # pairs:
    #   [ file1, [ aud1, sub1, tit1 ] ]
    #   [ file2, [ aud2, sub2, tit2 ] ]
    def data
      @data ||= @cfg.files.zip([@cfg.aud, @cfg.sub, @cfg.tit].transpose)
    end

    def m4v
      data.each do |f, as|
        res = @cfg.act? ? run(m4v_cmd(f, as[0], as[1], as[2])) : true
        @rep.add(f, res, as[0], as[1], as[2])
      end
    end

    def mp3_dst(file)
      "#{@cfg.out}/#{File.basename(file, '.*')}.mp3"
    end

    # Skips files whose destination MP3 already exists, so reruns only
    # convert what's missing.
    def mp3_files
      @cfg.files.reject do |f|
        dst = mp3_dst(f)
        File.exist?(dst).tap { |exists| warn "Skip: #{f} exists as #{dst}." if exists }
      end
    end

    # -q:a 0 requests libmp3lame's highest VBR quality (V0), letting
    # bitrate adapt to content complexity instead of spending a fixed
    # rate on simple passages. No -ar is given, so ffmpeg keeps the
    # source's sample rate when libmp3lame supports it directly (44100,
    # 48000, 32000, and others), instead of downsampling every file,
    # most commonly 48kHz video audio, to 44100.
    def mp3_cmd(file)
      "ffmpeg -nostdin -i #{file.shellescape} -ac 2 -f mp3 -q:a 0 -vn " \
        "#{mp3_dst(file)}"
    end

    def scn_cmd(file)
      "transcode-video --scan #{file.shellescape}"
    end

    def do
      if @cfg.mp3?
        mp3_files.each { |f| @rep.add(f, @cfg.act? ? run(mp3_cmd(f)) : true) }
      elsif @cfg.sca?
        @cfg.files.each { |f| @rep.add(f, run(scn_cmd(f))) }
      else
        m4v
      end
      @rep.do
    end
  end
end
