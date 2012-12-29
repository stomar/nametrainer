require 'minitest/spec'
require 'minitest/autorun'

require 'nametrainer/collection'
require 'nametrainer/collectionloader'

SRCPATH = File.dirname(__FILE__)  unless defined?(SRCPATH)

describe Nametrainer::Collection do

  before do
    extensions = %w{png jpg}
    @collection = Nametrainer::CollectionLoader.load("#{SRCPATH}/collection", extensions)
    @sample_scores = {
      'Albert Einstein' => 3,
      'Paul Dirac' => 1,
      'Max Born' => 2
    }
  end

  it 'can return a name list' do
    @collection.names.must_include 'Albert Einstein'
    @collection.names.must_include 'Paul Dirac'
    @collection.names.must_include 'Max Born'
  end

  it 'has a size' do
    @collection.size.must_equal 3
  end

  it 'can return all the scores' do
    scores = {
      'Albert Einstein' => 0,
      'Paul Dirac' => 0,
      'Max Born' => 0
    }
    @collection.scores.must_equal scores
  end

  it 'can set all the scores' do
    @collection.set_scores(@sample_scores)
    @collection.scores.must_equal @sample_scores
  end

  it 'can save the scores to a file and load them again and delete them' do
    @collection.set_scores(@sample_scores)
    @collection.export_scores
    @collection.first.score = nil
    @collection.import_scores
    @collection.scores.must_equal @sample_scores
    @collection.delete_scores
  end

  it 'can get sorted by the scores' do
    @collection.set_scores(@sample_scores)
    @collection.sort.first.name.must_equal 'Paul Dirac'
    @collection.sort.last.name.must_equal 'Albert Einstein'
  end

  it 'can return a random person' do
    @collection.sample.must_be_instance_of Nametrainer::Person
  end

  it 'can return the successor of a person' do
    p1 = @collection[0]
    p2 = @collection[1]
    p3 = @collection[2]
    @collection.successor(p1).name.must_equal p2.name
    @collection.successor(p2).name.must_equal p3.name
    @collection.successor(p3).name.must_equal p1.name
  end

  it 'can increase the score for a specified person' do
    person = @collection.last
    person.score.must_equal 0
    person.increase_score
    @collection.last.score.must_equal 1
  end

  # private methods
  it 'can return a weighted index list' do
    expected = [0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2,
                3, 3, 3, 4, 4, 4, 5, 5, 5,
                6, 6, 7, 7, 8, 8,
                9, 10, 11]
    indices = @collection.send(:indices_urn, :size => 12, :weighting_factor => 4)
    indices.sort.must_equal expected
  end

  it 'returns random indices in the correct range' do
    samples = 100
    indices = Array.new(samples) { @collection.send(:weighted_random_index) }
    indices.size.must_equal samples
    indices.sort.first.must_be :>=, 0
    indices.sort.last.must_be :<, @collection.size
  end
end
