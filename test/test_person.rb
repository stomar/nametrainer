require 'minitest/autorun'

require 'nametrainer/person'

describe Nametrainer::Person do

  before do
    @person = Nametrainer::Person.new('Albert Einstein', 'image01.jpg')
  end

  it 'has a name, an associated image file and a score' do
    @person.name.must_equal 'Albert Einstein'
    @person.image.must_equal 'image01.jpg'
    @person.score.must_equal 0
  end

  it 'can increase its score' do
    @person.score.must_equal 0
    @person.increase_score
    @person.score.must_equal 1
  end

  it 'can get sorted by score' do
    p1 = Nametrainer::Person.new('Albert', nil)
    p2 = Nametrainer::Person.new('Isaac', nil)
    p1.score = 1
    [p1, p2].sort.map{|p| p.name }.must_equal ['Isaac', 'Albert']
    p2.score = 2
    [p1, p2].sort.map{|p| p.name }.must_equal ['Albert', 'Isaac']
  end
end
