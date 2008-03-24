class Photo < ActiveRecord::Base
  belongs_to :user

  has_many :marks
  has_many :users, :through => :marks

  acts_as_scientiffic

end
