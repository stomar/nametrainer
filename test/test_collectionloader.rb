require 'minitest/spec'
require 'minitest/autorun'

require 'nametrainer/collectionloader'

SRCPATH = File.dirname(__FILE__)  unless defined?(SRCPATH)

describe Nametrainer::CollectionLoader do

  before do
    extensions = %w{png jpg}
    @collection = Nametrainer::CollectionLoader.load("#{SRCPATH}/collection", extensions)
  end

  it 'returns an array of Person instances' do
    @collection.class.must_equal Array
    @collection.first.class.must_equal Nametrainer::Person
  end

  it 'returns the correct number of Person instances' do
    @collection.size.must_equal 3
  end
end
