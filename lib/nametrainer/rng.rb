module Nametrainer

  # A random number generator.
  #
  # Get a random index from 0 to (size - 1) where smaller indices
  # are preferred with
  #
  #   RNG.rand(size)
  module RNG

    def self.rand(size)
      urn = indices_urn(:size => size, :weighting_factor => 100)

      urn[Kernel.rand(urn.size)]
    end

    # Returns an array of all indices from 0 to :size - 1, where lower indices are
    # more frequent than higher indices. Index 0 will be about :weighting_factor
    # times more probable then the highest index.
    def self.indices_urn(options)
      size = options[:size]
      weighting_factor = options[:weighting_factor]
      urn = Array.new
      # repeatedly add partial ranges of indices to urn
      1.upto(weighting_factor) do |i|
        count = (i.to_f/weighting_factor * size).ceil
        urn += (0...count).to_a
      end

      urn
    end
  end
end
