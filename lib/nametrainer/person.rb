module Nametrainer

  # A class for persons with name, image, and score.
  #
  # Create an instance with
  #   person = Person.new(name, image)
  #
  # Increase the score with
  #   person.increase_score
  #
  # You can sort Person instances by score:
  #   person1 = Person.new('Albert', nil)
  #   person2 = Person.new('Isaac', nil)
  #   person1.increase_score
  #   puts [person1, person2].sort.map{|p| p.name}  => Isaac, Albert
  class Person

    attr_reader :name, :image
    attr_accessor :score

    def initialize(name, image)
      @name = name
      @image = image
      @score = 0
    end

    # Increases the score by 1.
    def increase_score
      @score += 1
    end

    # Uses score for sorting.
    def <=>(other)
      self.score <=> other.score
    end
  end
end
