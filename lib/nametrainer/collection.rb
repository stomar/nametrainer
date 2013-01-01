require 'yaml'
require 'forwardable'

require 'nametrainer/rng'

module Nametrainer

  # A class for a collection of persons, each with a name,
  # a corresponding (image) file, and a score.
  #
  # Create a Collection instance with
  #   collection = CollectionLoader.load(
  #                  :directory  => directory,
  #                  :extensions => extensions
  #                )
  #
  # You can get a random person from a collection with
  #   person = collection.sample
  #
  # Persons with a lower score are chosen more often
  # than persons with a higher score.
  class Collection

    extend Forwardable
    def_delegators :@collection,
                   :size, :empty?, :[], :last, :index, :shuffle, :map, :each

    include Enumerable

    SCORE_FILE = 'nametrainer.dat'

    # Creates a Collection instance. Expects an argument hash with:
    #
    # +:persons+   - array of Person instances
    # +:directory+ - collection directory
    # +:rng+       - random number generator, defaults to RNG
    def initialize(args)
      @collection = args[:persons]
      @directory  = args[:directory]
      @rng        = args[:rng] || RNG.new(:size => @collection.size, :weighting_factor => 6)
    end

    # Returns an array of all names.
    def names
      map {|person| person.name }
    end

    # Returns a hash with the score of all persons (name => score).
    def scores
      Hash[map {|person| [person.name, person.score] }]
    end

    # Sets the score of some or all persons.
    #
    # +new_scores+ - hash with (name => score) values
    def set_scores(new_scores)
      each do |person|
        person.score = new_scores[person.name]  if new_scores[person.name]
      end
    end

    # Loads the scores from file (YAML).
    def import_scores
      filename = File.expand_path("#{@directory}/#{SCORE_FILE}")
      new_scores = YAML::load(File.read filename)
      set_scores(new_scores)
    end

    # Export all scores to file (YAML).
    def export_scores
      filename = File.expand_path("#{@directory}/#{SCORE_FILE}")
      File.open(filename, 'w') {|f| f.write(scores.to_yaml) }
    end

    # Delete score file.
    def delete_scores
      filename = File.expand_path("#{@directory}/#{SCORE_FILE}")
      File.delete(filename)
    end

    # Returns a random element, preferring persons with a smaller score.
    def sample
      shuffle.sort[@rng.rand]  # shuffle first to mix up elements with equal scores
    end

    # Returns the successor of the specified element, if possible,
    # or the first element.
    #
    # +element+ - element whose successor should be returned
    def successor(element)
      element_index = index(element)
      return first  unless element_index

      self[element_index + 1] || first
    end
  end
end
