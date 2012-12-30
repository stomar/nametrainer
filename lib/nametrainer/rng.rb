module Nametrainer

  # A random number generator.
  #
  # Get a random index from 0 to (size - 1), where smaller indices
  # are preferred, with
  #
  #   rng = RNG.new(:size => size, :weighting_factor => 6)
  #   rng.rand
  #
  # Index 0 will be about :weighting_factor times more probable
  # than the highest index.
  class RNG

    def initialize(args)
      @size = args[:size]
      @weighting_factor = args[:weighting_factor]
      @urn = indices_urn
    end

    def rand
      @urn[Kernel.rand(@urn.size)]
    end

    # Returns an array of all indices from 0 to :size - 1, where lower indices are
    # more frequent than higher indices. Index 0 will be about :weighting_factor
    # times more probable than the highest index.
    def indices_urn
      urn = Array.new
      # repeatedly add partial ranges of indices to urn
      1.upto(@weighting_factor) do |i|
        count = (i.to_f/@weighting_factor * @size).ceil
        urn += (0...count).to_a
      end

      urn
    end
  end
end
