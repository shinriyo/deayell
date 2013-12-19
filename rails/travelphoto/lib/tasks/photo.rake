namespace :photo do
  desc "gps update"
  task :gps  => :environment do
    photos = Photo.find(:all)
    photos.each do |photo|
      PhotoWorker.perform_async(photo.id)
    end
  end
end
