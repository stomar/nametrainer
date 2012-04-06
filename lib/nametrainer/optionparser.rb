require 'optparse'

require 'nametrainer/version'

module Nametrainer

  # Parser for the command line options.
  # The class method parse! does the job.
  class Optionparser

    # Parses the command line options from +argv+.
    # (+argv+ is cleared).
    # Might print out help or version information.
    #
    # +argv+ - array with the command line options
    #
    # Returns a hash containing the option parameters.
    def self.parse!(argv)

      options = {
        :collection => nil,
        :demo       => false
      }

      opt_parser = OptionParser.new do |opt|
        opt.banner = "Usage: #{PROGNAME} [options] [collection]"
        opt.separator ''
        opt.separator "#{PROGNAME} is a name learning trainer using Ruby and the Qt GUI toolkit."
        opt.separator "It will assist you in learning people's names from a collection of images."
        opt.separator ''
        opt.separator 'See the project home page for additional information.'
        opt.separator ''
        opt.separator 'Options'
        opt.separator ''

        # process --version and --help first,
        # exit successfully (GNU Coding Standards)
        opt.on_tail('-h', '--help', 'Prints a brief help message and exits.') do
          puts opt_parser
          puts "\nReport bugs on the #{PROGNAME} home page: <#{HOMEPAGE}>"
          exit
        end

        opt.on_tail('-v', '--version',
                    'Prints a brief version information and exits.') do
          puts "#{PROGNAME} #{VERSION}"
          puts COPYRIGHT
          exit
        end

        opt.on('-d', '--demo', 'Starts the application with a demo collection.') do
          options[:demo] = true
        end

        opt.separator ''
      end
      opt_parser.parse!(argv)

      # only collection directory should be left in argv
      if options[:demo]
        raise(ArgumentError, 'wrong number of arguments')  if (argv.size != 0 || argv[0] == '')
      else
        raise(ArgumentError, 'wrong number of arguments')  if (argv.size > 1 || argv[0] == '')
        options[:collection] = argv.pop  if argv.size == 1
      end

      options
    end
  end
end
