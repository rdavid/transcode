# frozen_string_literal: true

# vi: et lbr sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2018-2026 David Rabkin
# SPDX-License-Identifier: 0BSD

require 'English'
require 'shellwords'
require_relative 'configurator'
require_relative 'reporter'

module Transcode
  # Runs the conversion, MP3, or scan commands and reports the results.
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

    # Builds the transcode-video command for one file. A value of '0'
    # leaves the audio, subtitle, or title choice to transcode-video.
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

    # Pairs each file with its audio, subtitle, and title values:
    #   [ file1, [ aud1, sub1, tit1 ] ]
    #   [ file2, [ aud2, sub2, tit2 ] ]
    def data
      @data ||= @cfg.files.zip([@cfg.aud, @cfg.sub, @cfg.tit].transpose)
    end

    # Converts every file to m4v. A dry run only reports the files.
    def m4v
      data.each do |f, as|
        res = @cfg.act? ? run(m4v_cmd(f, as[0], as[1], as[2])) : true
        @rep.add(f, res, as[0], as[1], as[2])
      end
    end

    # Returns the MP3 path in the output directory for a source file.
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

    # Builds the ffmpeg command that extracts stereo audio to MP3. The
    # -q:a 0 option requests libmp3lame's highest VBR quality (V0), letting
    # bitrate adapt to content complexity instead of spending a fixed
    # rate on simple passages. No -ar is given, so ffmpeg keeps the
    # source's sample rate when libmp3lame supports it directly (44100,
    # 48000, 32000, and others), instead of downsampling every file,
    # most commonly 48kHz video audio, to 44100.
    def mp3_cmd(file)
      "ffmpeg -nostdin -i #{file.shellescape} -ac 2 -f mp3 -q:a 0 -vn " \
        "#{mp3_dst(file)}"
    end

    # Builds the command that lists the audio and subtitle tracks of a file.
    def scn_cmd(file)
      "transcode-video --scan #{file.shellescape}"
    end

    # Runs the mode the options select, then prints the summary table.
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
