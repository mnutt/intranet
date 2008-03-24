class Tag < ActiveRecord::Base
  validates_presence_of :name
  before_save { |t| t.name.downcase! }
  has_many :taggings
  has_many :users, :through => :taggings

  class << self
    def parse_tag(tag)
      tag.split(',').collect { |s| s.strip }
    end
    
    def parse_and_create_tags(tag)
      parse_tag(tag).collect { |t| find_or_create_by_name(t.downcase) }
    end
  end
  
  def to_param ; name ; end
end
