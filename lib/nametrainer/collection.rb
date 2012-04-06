require 'set'
require 'yaml'

require 'nametrainer/person'

module Nametrainer

  # A Class for a collection of persons, each with a name,
  # a corresponding (image) file, and a score.
  # A collection is an array of instances of the Person class.
  #
  # Open a collection with
  #   collection = Collection.new(directory, extensions)
  #
  # For each file with an extension from the +extensions+ array a Person
  # instance is created, using the file name as the person's name
  # (extension is removed, underscore is converted to space)
  # or the content of a corresponding `txt' file, and the file name as
  # the +image+ attribute.
  #
  # You can get a random person from a collection with
  #   person = collection.sample
  #
  # Persons with a lower score are chosen more often
  # than persons with a higher score.
  class Collection < Array

    SCORE_FILE = 'nametrainer.dat'

    # Creates a Collection instance.
    # It searches in +directory+ for files with the given
    # file extensions (also in upper case) and populates
    # the collection with corresponding Person instances.
    #
    # +directory+ - collection directory
    # +extension+ - array of file extensions
    def initialize(directory, extensions)
      super()
      @directory = directory
      @extensions = extensions.to_set
      @extensions.merge extensions.map {|i| i.upcase}
      self.concat self.class.load(@directory, @extensions.to_a)
    end

    # Returns an array of all names.
    def names
      all_names = Array.new
      self.each do |person|
        all_names << person.name
      end

      all_names
    end

    # Returns a hash with the score of all persons (name => score).
    def scores
      all_scores = {}
      self.each do |person|
        all_scores[person.name] = person.score
      end

      all_scores
    end

    # Sets the score of some or all persons.
    #
    # +new_scores+ - hash with (name => score) values
    def set_scores(new_scores)
      self.each do |person|
        person.score = new_scores[person.name]  unless new_scores[person.name].nil?
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
      File.open(filename, 'w') do |f|
        f.write(scores.to_yaml)
      end
    end

    # Returns a random element, preferring persons with a smaller score.
    def sample
      self.shuffle.sort[weighted_random_index]  # shuffle first, so that elements with equal scores get mixed up
    end

    private

    # Returns a random index (obsolete).
    def random_index
      rand(self.size)
    end

    # Returns a random index, preferring smaller indices.
    def weighted_random_index
      max_index = self.size - 1
      weighting_factor = 6  # index 0 will be about weighting_factor times more probable than max_index

      # construct an array with indices by repeatedly adding different parts of a range of indices
      indices = Array.new
      range = Array.new(self.size) {|i| i }
      1.upto(weighting_factor) do
        |i| indices += range[0..(i.to_f/weighting_factor * max_index).ceil]
      end

      indices[rand(indices.size)]
    end

    # class methods

    # Load a collection. Returns an array of Person instances.
    def self.load(directory, extensions)
      extension_list = extensions.join(',')
      files = Dir.glob("#{directory}/*.{#{extension_list}}")
      result = Array.new
      files.each do |file|
        name = get_name(file, extensions)
        result << Person.new(name, file)
      end

      result
    end

    # Get name from corresponding `txt' file or
    # from file name (remove extension, convert underscores).
    def self.get_name(file, extensions)
      name = file.dup
      extensions.each {|ext| name.gsub!(/\.#{ext}$/, '') }  # remove file extension
      begin
        info_file = "#{name}.txt"
        File.read(info_file).chomp
      rescue
        File.basename(name).tr('_', ' ')
      end
    end
  end
end
