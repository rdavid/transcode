# frozen_string_literal: true

# vi:ts=2 sw=2 tw=79 et lbr wrap
# Copyright 2018-present David Rabkin

require 'optparse'

module Transcode
  # Handles input parameters.
  class Configurator # rubocop:disable Metrics/ClassLength
    attr_reader :files
    DIC = [
      ['-a', '--act', 'Real encoding.', nil, :act],
      ['-s', '--sca', 'Scans files at the directory.', nil, :sca],
      ['-m', '--mp3', 'Converts files to mp3.', nil, :mp3],
      ['-d', '--dir dir', 'Directory to transcode.', String, :dir],
      ['-i', '--tit tit', 'Specific title by number.', Array, :tit],
      ['-o', '--out out', 'Directory to output.', String, :out],
      ['-u', '--aud aud', 'Audio stream numbers.', Array, :aud],
      ['-t', '--sub sub', 'Subtitle stream numbers.', Array, :sub],
      ['-w', '--wid wid', 'Width of the table.', Integer, :wid]
    ].freeze
    EXT = %i[
      avi flv m4v mkv mp4 mpg mpeg ts webm vob wmv
    ].map(&:to_s).join(',').freeze

    def initialize
      @options = {}
      OptionParser.new do |o|
        o.banner = "Usage: #{File.basename($PROGRAM_NAME)} [options]."
        DIC.each { |f, p, d, t, k| o.on(f, p, t, d) { |i| @options[k] = i } }
      end.parse!
      find_dir
      find_fil
      validate
    end

    def find_dir
      if dir.nil?
        @options[:dir] = Dir.pwd
      else
        raise "No such directory: #{dir}." unless File.directory?(dir)

        @options[:dir] = File.expand_path(dir)
      end
      @options[:out] = File.expand_path(out.nil? ? '~' : out)
    end

    def find_fil
      @files = Dir.glob("#{dir}/*.{#{EXT}}").select { |f| File.file? f }
      sub = !mp3?
      @files += Dir.glob("#{dir}/*").select { |f| File.directory? f } if sub
      @files.sort_by!(&:naturalized)
      @files.sort_by!(&:swapcase)
    end

    def validate
      validate_files
      validate_tit
      validate_val(aud, :aud)
      validate_val(sub, :sub)
      raise "Width of the table should exeeds 14 symbols: #{wid}." if wid < 15
    end

    def validate_files
      raise "#{dir} doesn't have #{EXT} files or directories." if files.empty?

      bad = files.reject { |f| File.readable?(f) }
      raise "Unable to read #{bad} files." unless bad.empty?
    end

    def validate_tit # rubocop:disable Metrics/AbcSize
      if tit.nil?
        @options[:tit] = Array.new(files.size, '0')
        return
      end
      if files.size == 1
        @files = Array.new(tit.size, files.first)
        return
      end
      raise "Title feature doesn't support #{files.size} files."
    end

    def validate_val(val, tag)
      f = files.size
      (@options[tag] = Array.new(f, '0')).nil? || return if val.nil?

      s = val.size
      if s == 1
        @options[tag] = Array.new(f, val.first)
      else
        raise "#{tag} and files do not suit #{s} != #{f}." unless s == f
      end
    end

    def act?
      @options[:act]
    end

    def sca?
      @options[:sca]
    end

    def mp3?
      @options[:mp3]
    end

    def dir
      @options[:dir]
    end

    def tit
      @options[:tit]
    end

    def out
      @options[:out]
    end

    def aud
      @options[:aud]
    end

    def sub
      @options[:sub]
    end

    def wid
      if @options[:wid].nil?
        # Reads current terminal width.
        wid = `tput cols`
        wid.to_s.empty? ? 79 : wid.to_i
      else
        @options[:wid].to_i
      end
    end
  end
end
