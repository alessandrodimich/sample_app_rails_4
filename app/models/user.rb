class User < ActiveRecord::Base

  has_secure_password

  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower


  before_create { create_remember_token }
  #before_create { create_star_token }
  before_save { self.email = email.downcase }


  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }

  #Session token


  #Multipurpose browser permanent token
  # def create_star_token
  #    self.star_token = Digest::SHA1.hexdigest(Time.now.to_f.to_s.sub(".", "") + self.email.to_s )
  #    self.update_attribute(:star_token, self.star_token)
  # end



  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy!
  end

  def send_password_reset
      self.password_reset_token = Digest::SHA1.hexdigest(Time.now.to_f.to_s.sub(".", "") + self.email.to_s)
      self.password_reset_sent_at = Time.now
      self.update_columns(:password_reset_token => self.password_reset_token, :password_reset_sent_at => self.password_reset_sent_at )
      UserMailer.reset_password(self).deliver
  end

#Private methods go below
private

  def create_remember_token
    self.remember_token = Digest::SHA1.hexdigest(Time.now.to_f.to_s.sub(".", "") + self.email.to_s)
    self.update_attribute(:remember_token, self.remember_token)
  end




end
