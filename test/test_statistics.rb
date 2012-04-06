require 'minitest/spec'
require 'minitest/autorun'

require 'nametrainer/statistics'

describe Nametrainer::Statistics do

  before do
    @stats = Nametrainer::Statistics.new
  end

  it 'has the correct initial values' do
    @stats.correct.must_equal 0
    @stats.wrong.must_equal 0
    @stats.total.must_equal 0
  end

  it 'can set its attributes' do
    @stats.correct = 3
    @stats.correct.must_equal 3
    @stats.wrong = 2
    @stats.wrong.must_equal 2
  end

  it 'knows the total' do
    @stats.correct = 8
    @stats.wrong = 2
    @stats.total.must_equal 10
  end

  it 'can be reset' do
    @stats.correct = 12
    @stats.wrong = 8
    @stats.total.must_equal 20
    @stats.reset
    @stats.total.must_equal 0
  end

  it 'can print the statistics for total = 0' do
    @stats.to_s.must_equal '0 % (0/0)'
  end

  it 'can print the statistics' do
    @stats.correct = 9
    @stats.wrong = 11
    @stats.to_s.must_equal '45 % (9/20)'
  end
end
