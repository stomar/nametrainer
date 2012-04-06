require 'minitest/spec'
require 'minitest/autorun'

require 'nametrainer/optionparser'

describe Nametrainer::Optionparser do

  it 'should return the correct default values' do
    options = Nametrainer::Optionparser.parse!(['collection'])
    expected = {
      :collection => 'collection',
      :demo => false
    }
    options.must_equal expected
  end

  it 'should recognize the -d option' do
    options = Nametrainer::Optionparser.parse!(['-d'])
    options[:collection].must_be_nil
    options[:demo].must_equal true
  end

  it 'should not accept wrong number of arguments' do
    lambda { Nametrainer::Optionparser.parse!(['collection1', 'collection2']) }.must_raise ArgumentError
    lambda { Nametrainer::Optionparser.parse!(['']) }.must_raise ArgumentError
    lambda { Nametrainer::Optionparser.parse!(['-d', 'collection']) }.must_raise ArgumentError
  end

  it 'should not accept invalid options' do
    lambda { Nametrainer::Optionparser.parse!(['-x']) }.must_raise OptionParser::InvalidOption
  end
end
