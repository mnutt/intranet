require File.join(File.dirname(__FILE__), 'abstract_unit')

# All sizes are commented out because they vary wildly among platforms
class RandomModelTest < Test::Unit::TestCase
  fixtures :random_models, :horses

  def test_should_not_raise_error
    assert_nothing_raised { RandomModel.find(:all, :order => :random) }
  end

  def test_should_not_raise_error_on_association
    assert_nothing_raised { RandomModel.find(:first).horses.find(:all, :order => :random) }
  end

end
