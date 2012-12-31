module Nametrainer

  # A random number generator.
  #
  # Get a random index from 0 to (size - 1), where smaller indices
  # are preferred, with
  #
  #   rng = RNG.new(:size => size, :weighting_factor => 6)
  #   rng.rand
  #
  # Index 0 will be :weighting_factor times more probable
  # than the highest index.
  class RNG

    def initialize(args)
      @size = args[:size]
      @weighting_factor = args[:weighting_factor]

      @limits = normalized_limits
    end

    #--
    # Weighted random numbers in the range from 0 to (size - 1).
    #
    # Divide the range [0;1) into intervals with size depending
    # on the desired weight. Choose a (evenly distributed)
    # random number and return the number that corresponds to
    # the interval within it lies.
    #++
    def rand
      x = Kernel.rand
      interval = @limits.find_index {|limit| x < limit }

      interval || (@size - 1)
    end

    private

    # Returns a list of weighting factors from @weighting_factor to 1.
    def weighting_factors
      delta = (@weighting_factor - 1).to_f / (@size - 1)

      Array.new(@size) {|index| @weighting_factor - index * delta}
    end

    # Returns a list of upper limits for all intervals.
    def raw_limits
      limits = weighting_factors.dup
      1.upto(@size - 1) do |index|
        limits[index] = limits[index-1] + limits[index]
      end

      limits
    end

    # Returns a list of upper limits normalized to the range [0;1).
    def normalized_limits
      max = raw_limits.last

      raw_limits.map {|limit| limit.to_f / max }
    end
  end
end
