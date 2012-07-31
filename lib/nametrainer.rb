# == Name
#
# nametrainer - name learning trainer
#
# == Synopsis
#
#    nametrainer [options] [collection]
#
# == Description
#
# +nametrainer+ is a name learning trainer using Ruby and the Qt GUI toolkit.
# It will assist you in learning people's names from a collection of images.
#
# See the project home page for additional information:
# https://github.com/stomar/nametrainer/
#
# == Options
#
# -d, --[no-]demo:: Starts the application with a demo collection.
#
# -h, --help:: Prints a brief help message and exits.
#
# -v, --version:: Prints a brief version information and exits.
#
# == Author
#
# Copyright (C) 2012 Marcus Stollsteimer
#
# License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

require 'nametrainer/gui'
require 'nametrainer/person'
require 'nametrainer/collection'
require 'nametrainer/optionparser'
require 'nametrainer/statistics'
require 'nametrainer/version'

# This module contains the classes for the +nametrainer+ tool.
module Nametrainer

  FILE_EXTENSIONS = %w{png jpg jpeg}

  # Returns a string with all accepted image file extensions.
  def self.extension_string
    "#{FILE_EXTENSIONS[0...-1].join(', ').upcase}, or #{FILE_EXTENSIONS.last.upcase}"
  end

  # Returns the warning message for an empty collection.
  def self.collection_empty_message
    'Could not load collection.<br><br>' +
    "Maybe the specified directory does not exist or contains no #{extension_string} files."
  end

  # Returns the text for the help window.
  def self.help_message
    <<-HELPTEXT
    <big>Basic Functions / Keyboard Shortcuts</big><br>

    <table>
    <tr><td>Display name &nbsp;&nbsp;&nbsp;</td>
        <td>Shows the person's name (<strong>D</strong>)</td></tr>
    <tr><td>Correct</td>
        <td>You know this person (<strong>S</strong>)</td></tr>
    <tr><td>Wrong</td>
        <td>You do not know this person yet (<strong>F</strong>)</td></tr>
    <tr><td>Quit</td>
        <td>Quit (<strong>Ctrl+W</strong>)</td></tr>
    </tr>
    </table>
    <br><br>

    <big>Collections</big><br><br>

    A collection is simply a diretory with image files.
    #{PROGNAME} uses the file name as the person's display name
    or the content of a corresponding TXT file.<br><br>

    Accepted file formats: #{extension_string}.<br><br>

    Please note: JPG files may not be supported on Windows;
    in this case use PNG images instead.<br><br>

    <big>About</big><br><br>

    <b>#{PROGNAME}</b> version #{VERSION} (#{DATE})<br><br>

    Project home page:
    <a href='#{HOMEPAGE}'>#{HOMEPAGE.gsub(%r{https?://}, '')}</a><br><br>

    #{COPYRIGHT.lines.first.gsub(/\(C\)/, '&copy;')}<br>
    For license information use <code>#{PROGNAME} -v</code>.
    HELPTEXT
  end
end
