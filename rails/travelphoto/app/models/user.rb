class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable

  devise :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :username
  attr_accessible :provider, :uid, :name
  # attr_accessible :title, :body

  has_many :travels
  has_many :photos
  has_many :friends
  has_many :followings, :through => :friends

  validates_uniqueness_of :username

  scope :search_friends, lambda {|username| where("username like :username", username: "%#{username}%" )}


def self.find_for_facebook_from_api(params, current_user = nil)
  user = User.where(:provider => "facebook", :uid => params[:uid]).first
  if current_user
    if params.has_key?(:uid)
      current_user.provider = "facebook"
      current_user.uid = params[:uid].to_i
      current_user.save!
      current_user.reload
    end
    return current_user
  else
    unless user
      user = User.new(username: params[:username],
                      provider: "facebook",
                      uid: params[:uid],
                      email: params[:email],
                      password: Devise.friendly_token[0,20]
                         )
      user.skip_confirmation!
      user.save
    end
  end
  user
end


def self.find_for_facebook_oauth(auth, current_user=nil)
  user = User.where(:provider => auth.provider, :uid => auth.uid).first
  if current_user
    current_user.provider = auth.provider
    current_user.uid = auth.uid
    current_user.save!
    current_user.reload
    return current_user
  else
    unless user
    user = User.new(
                    username:auth.extra.raw_info.name,
                    provider:auth.provider,
                    uid:auth.uid,
                    email:auth.info.email,
                    password:Devise.friendly_token[0,20]
                    )
    user.skip_confirmation!
    user.save
    end
  end
  user
end


  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

end
