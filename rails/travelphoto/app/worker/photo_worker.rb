class PhotoWorker
  include Sidekiq::Worker
  def perform photo_id
    photo = Photo.find(photo_id)
    gps = EXIFR::JPEG.new(photo.image.path).gps
   if gps
     photo.lat = gps.latitude
     photo.lon = gps.longitude
     photo.save!
   end

  end
end
