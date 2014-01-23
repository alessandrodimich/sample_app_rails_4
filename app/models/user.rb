class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }

<<<<<<< HEAD

  def create_remember_token
    self.remember_token = Digest::SHA1.hexdigest(Time.now.to_f.to_s.sub(".", "") + self.email.to_s)
    self.update_attribute(:remember_token, self.remember_token)
  end

  def destroy_remember_token
    self.remember_token = ""
    self.update_attribute(:remember_token, self.remember_token)
  end

=======
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

>>>>>>> parent of 2ba2a17... Revert e89b86d..b031a90
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

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

<<<<<<< HEAD
  # Put private methods below
  private


=======
  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
>>>>>>> parent of 2ba2a17... Revert e89b86d..b031a90
end
