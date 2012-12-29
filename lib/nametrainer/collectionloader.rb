require 'set'

require 'nametrainer/person'

module Nametrainer

  # CollectionLoader.load loads a collection from a directory
  # and returns an array of Person instances.
  #
  # It searches in the directory for files with the given
  # file extensions (ignoring case) and for each creates
  # a Person instance, using the file name as the person's name
  # (extension is removed, underscore is converted to space)
  # or the content of a corresponding `txt' file, and the file name as
  # the +image+ attribute.
  module CollectionLoader

    # Loads a collection. Returns an array of Person instances.
    #
    # +directory+ - collection directory
    # +extension+ - array of file extensions
    def self.load(directory, extensions)
      pattern = extensions.map {|ext| ext.downcase }.uniq.join('|')
      valid_extensions = /\.(#{pattern})\Z/i
      files = Dir.glob("#{directory}/*").grep(valid_extensions)

      files.sort.map {|file| Person.new(get_name(file), file) }
    end

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
