# Transcode

[![build](https://ci.appveyor.com/api/projects/status/yqxb43ltxrjj776a?svg=true)](https://ci.appveyor.com/project/rdavid/transcode)
[![linters](https://github.com/rdavid/transcode/actions/workflows/lint.yml/badge.svg)](https://github.com/rdavid/transcode/actions/workflows/lint.yml)
[![ruby](https://github.com/rdavid/transcode/actions/workflows/ruby.yml/badge.svg)](https://github.com/rdavid/transcode/actions/workflows/ruby.yml)
[![gem version](https://badge.fury.io/rb/transcode.svg)](https://badge.fury.io/rb/transcode)
[![maintainability](https://api.codeclimate.com/v1/badges/5e21a1c1f8a3923584e3/maintainability)](https://codeclimate.com/github/rdavid/transcode/maintainability)
[![hits of code](https://hitsofcode.com/github/rdavid/transcode?branch=master&label=hits%20of%20code)](https://hitsofcode.com/view/github/rdavid/transcode)
[![license](https://img.shields.io/github/license/rdavid/transcode?color=blue&labelColor=gray&logo=freebsd&logoColor=lightgray&style=flat)](https://github.com/rdavid/transcode/blob/master/LICENSE)

* [About](#about)
* [Installation](#installation)
* [Usage](#usage)
* [License](#license)

## About

`transcode` is a tool to transcode multiple video files. It enhances
[Don Melton](http://donmelton.com/)'s [Video
Transcoding](https://github.com/donmelton/video_transcoding/). It applies
Video Trascoding to each video file in a directory.

## Installation

The tool is designed to work on macOS, GNU/Linux, Windows, Unix-like OS. It is
packaged as a Gem and require Ruby version 2.6 or later. See “[Installing
Ruby](https://www.ruby-lang.org/en/documentation/installation/)” if you don't
have the proper version on your platform.

Use this command to install:

```sh
gem install transcode
```

### Updating

Use this command to update the package:

```sh
gem update transcode
```

### Requirements

See Video Transcoding's [requirements](https://github.com/donmelton/video_transcoding/blob/master/README.md?ts=2#requirements).

### Usage

```sh
transcode [options]
  -a, --act      Real encoding.
  -s, --sca      Scans files at the directory.
  -m, --mp3      Converts files to mp3.
  -d, --dir dir  Directory to transcode.
  -i, --tit tit  Specific title by number.
  -o, --out out  Directory to output.
  -u, --aud aud  Audio stream numbers.
  -t, --sub sub  Subtitle stream numbers.
  -w, --wid wid  Width of the table.
  -v, --version  Shows version.
```

### Example

```sh
transcode -d <source> -o <destination> -u 1,3,1 -t 2,1,3
```

It converts three files from source with certain audio and subtitle streams.
Inspect first with `-s` option to see audio and subtitle streams.

## License

`transcode` is copyright [David Rabkin](http://cv.rabkin.co.il) and
available under a [Zero-Claus BSD license](https://github.com/rdavid/transcode/blob/master/LICENSE).
