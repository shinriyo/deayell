class Travel < ActiveRecord::Base
  attr_accessible :enddate, :startdate, :title
  validates_presence_of :enddate, :startdate, :title

  has_many :albums

  belongs_to :user
  belongs_to :cover_photo, :class_name => "Photo", :foreign_key => "photo_id"

  after_create :create_album

  def gps
    return nil if self.albums.first.photos.count == 0
    if self.cover_photo && self.cover_photo.lat != nil

      photo = self.cover_photo
    else
      album = self.albums.first
      photo = Photo.find(:first,:conditions => ["album_id = ? and lat is not null",album.id])
    end
    if photo
      return {:id => self.id, :title => self.title ,:photo_id => photo.id , :lat => photo.lat , :lon => photo.lon, :thumb_url => photo.image.url(:thumb)}
    else
      nil
    end
    

  end

  private
  def create_album
    self.albums.create(:title => self.title)
  end

end
