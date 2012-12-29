require 'set'

require 'nametrainer/person'
require 'nametrainer/collection'

module Nametrainer

  # CollectionLoader.load loads a collection from a directory
  # and returns a Collection instance.
  #
  # It searches in the directory for files with the given
  # file extensions (ignoring case) and for each file creates
  # a Person instance, using the file name as the person's +name+
  # (extension is removed, underscore is converted to space)
  # or the content of a corresponding `txt' file,
  # and the file name as the +image+ attribute.
  module CollectionLoader

    # Loads a collection. Returns a Collection instance.
    #
    # +directory+  - collection directory
    # +extensions+ - array of file extensions
    def self.load(directory, extensions)
      pattern = extensions.map {|ext| ext.downcase }.uniq.join('|')
      valid_extensions = /\.(#{pattern})\Z/i
      files = Dir.glob("#{directory}/*").grep(valid_extensions)
      persons = files.sort.map {|file| Person.new(get_name(file), file) }

      Collection.new(persons, directory)
    end

    private

    # Get name from corresponding `txt' file or
    # from file name (remove extension, convert underscores).
    def self.get_name(file)
      name = file.gsub(/#{File.extname(file)}\Z/, '')
      begin
        info_file = "#{name}.txt"
        File.read(info_file).chomp
      rescue
        File.basename(name).tr('_', ' ')
      end
    end
  end
end
