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

  it 'returns random indices with the expected frequency' do
    samples = 100000
    indices = Array.new(samples) { @rng.rand }

    frequency = Hash.new {|h, k| h[k] = 0 }
    indices.each do |index|
      frequency[index] += 1
    end
    relative_frequency = frequency.sort.map {|ind, freq| freq.to_f/samples }

    expected = [4.0/30, 4.0/30, 4.0/30, 3.0/30, 3.0/30, 3.0/30,
                2.0/30, 2.0/30, 2.0/30, 1.0/30, 1.0/30, 1.0/30]
    relative_frequency.each_with_index do |freq, index|
      freq.must_be_within_epsilon expected[index], 0.05
    end
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
