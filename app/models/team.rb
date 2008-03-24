class Team < ActiveRecord::Base
  has_many :positions, :dependent => :destroy
  has_many :users, :through => :positions

  def to_param
    name
  end
end
