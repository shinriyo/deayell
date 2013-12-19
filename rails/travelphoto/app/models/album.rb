class Album < ActiveRecord::Base
  attr_accessible :title, :travel
  belongs_to :travel
  has_many :photos
end
