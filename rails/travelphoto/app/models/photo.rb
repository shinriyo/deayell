class Photo < ActiveRecord::Base
  belongs_to :user
  belongs_to :album
  attr_accessible :comment, :title, :image, :user, :album
  has_attached_file :image, :styles => { :thumb => ["64x64#", :png] }

  has_one :travel

end
