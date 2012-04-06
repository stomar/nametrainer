module Nametrainer

  # A class for statistics.
  #
  # It keeps track of the number of correct and wrong answers.
  #
  # Create an instance with
  #   stats = Statistics.new
  #
  # Set the values
  #   stats.correct = 6
  #   stats.wrong = 2
  #
  # Print the percentage
  #   puts stats.to_s  => 75 % (6/8)
  class Statistics

    attr_accessor :correct, :wrong

    def initialize
      reset
    end

    # Resets all values to zero.
    def reset
      @correct = 0
      @wrong = 0
    end

    # Returns the total number of answers.
    def total
      @correct + @wrong
    end

    # Returns a string with percentage and correct and total answers.
    def to_s
      percent = (total == 0) ? 0 : (@correct.to_f / total.to_f * 100).to_i

      "#{percent} % (#{@correct}/#{total})"
    end
  end
end
