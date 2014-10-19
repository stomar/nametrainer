require 'minitest/autorun'

require 'nametrainer/collectionloader'

SRCPATH = File.dirname(__FILE__)  unless defined?(SRCPATH)

describe Nametrainer::CollectionLoader do

  before do
    args = {
      :directory  => "#{SRCPATH}/collection",
      :extensions => %w{png JPG}
    }
    @collection = Nametrainer::CollectionLoader.load(args)
  end

  it 'returns a Collection instance' do
    @collection.class.must_equal Nametrainer::Collection
    @collection.first.class.must_equal Nametrainer::Person
  end

  it 'returns a collection with the correct size' do
    @collection.size.must_equal 3
  end
end
