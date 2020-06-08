# Transcode
Tool to transcode batch of video files.

[![Build
Status](https://travis-ci.org/rdavid/transcode.svg)](https://travis-ci.org/rdavid/transcode)
[![Build
status](https://ci.appveyor.com/api/projects/status/yqxb43ltxrjj776a?svg=true)](https://ci.appveyor.com/project/rdavid/transcode)
[![Gem
Version](https://badge.fury.io/rb/transcode.svg)](https://badge.fury.io/rb/transcode)
[![Maintainability](https://api.codeclimate.com/v1/badges/5e21a1c1f8a3923584e3/maintainability)](https://codeclimate.com/github/rdavid/transcode/maintainability)

[![Hits-of-Code](https://hitsofcode.com/github/rdavid/transcode)](https://hitsofcode.com/view/github/rdavid/transcode)
[![License](https://img.shields.io/github/license/rdavid/transcode)](https://github.com/rdavid/transcode/blob/master/LICENSE.txt)

* [About](#about)
* [Installation](#installation)
* [Usage](#usage)
* [License](#license)

## About
Hi, I'm [David Rabkin](https://www.rabkin.co.il). I created this tool to
enhance [Don Melton](http://donmelton.com/)'s [Video
Transcoding](https://github.com/donmelton/video_transcoding/). It applies
Video Trascoding to each video file in a directory.

## Installation
The tool is designed to work on macOS, GNU/Linux, Windows, Unix-like OS. It is
packaged as a Gem and require Ruby version 2.6 or later.  See «[Installing
Ruby](https://www.ruby-lang.org/en/documentation/installation/)» if you don't
have the proper version on your platform.

Use this command to install:

    gem install transcode

### Updating
Use this command to update the package:

    gem update transcode

### Requirements
See Video Transcoding's [requirements](https://github.com/donmelton/video_transcoding/blob/master/README.md?ts=2#requirements).

## Usage
    transcode [options]
      -a, --act                        Real encoding.
      -s, --sca                        Scans files at the directory.
      -m, --mp3                        Converts files to mp3.
      -d, --dir dir                    Directory to transcode.
      -i, --tit tit                    Specific title by number.
      -o, --out out                    Directory to output.
      -u, --aud aud                    Audio stream numbers.
      -t, --sub sub                    Subtitle stream numbers.
      -w, --wid wid                    Width of the table.

### Example
    transcode -d <source> -o <destination> -u 1,3,1 -t 2,1,3

It converts three files from source with certain audio and subtitle streams.
Inspect first with `-s` option to see audio and subtitle streams.

## License
Transcode is copyright [David Rabkin](http://www.rabkin.co.il/) and
available under a [2-Claus BSD license](https://github.com/rdavid/transcode/blob/master/LICENSE).
