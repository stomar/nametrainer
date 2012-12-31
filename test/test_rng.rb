require 'minitest/spec'
require 'minitest/autorun'

require 'nametrainer/rng'

describe Nametrainer::RNG do

  before do
    @size = 7
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

    expected = [4.0/17.5, 3.5/17.5, 3.0/17.5, 2.5/17.5,
                2.0/17.5, 1.5/17.5, 1.0/17.5]
    relative_frequency.each_with_index do |freq, index|
      freq.must_be_within_epsilon expected[index], 0.05
    end
  end

  it 'can return a list of weighting factors' do
    expected = [4, 3.5, 3, 2.5, 2, 1.5, 1]
    factors = @rng.send(:weighting_factors)
    factors.each_index do |index|
      factors[index].must_be_close_to expected[index]
    end
  end

  it 'can return a list of limits' do
    expected = [4, 7.5, 10.5, 13, 15, 16.5, 17.5]
    raw_limits = @rng.send(:raw_limits)
    raw_limits.each_index do |index|
      raw_limits[index].must_be_close_to expected[index]
    end
  end

  it 'can return a list of normalized limits' do
    expected = [4/17.5, 7.5/17.5, 10.5/17.5, 13/17.5,
                15/17.5, 16.5/17.5, 17.5/17.5]
    normalized_limits = @rng.send(:normalized_limits)
    normalized_limits.each_index do |index|
      normalized_limits[index].must_equal expected[index]
    end
  end
end
