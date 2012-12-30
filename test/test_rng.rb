require 'minitest/spec'
require 'minitest/autorun'

require 'nametrainer/rng'

describe Nametrainer::RNG do

  before do
    @size = 12
    @rng = Nametrainer::RNG.new(:size => @size, :weighting_factor => 4)
  end

  it 'returns random indices in the correct range' do
    samples = 100
    indices = Array.new(samples) { @rng.rand }
    indices.size.must_equal samples
    indices.sort.first.must_be :>=, 0
    indices.sort.last.must_be :<, @size
  end

  it 'can return a weighted index list' do
    expected = [0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2,
                3, 3, 3, 4, 4, 4, 5, 5, 5,
                6, 6, 7, 7, 8, 8,
                9, 10, 11]
    indices = @rng.indices_urn
    indices.sort.must_equal expected
  end
end
