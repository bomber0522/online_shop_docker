class Member < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
               format: { with: VALID_EMAIL_REGEX },
               uniqueness: { case_sensitive: false }
  has_secure_password

  has_many :entries, dependent: :destroy
  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :votes, dependent: :destroy
  has_many :voted_entries, through: :votes, source: :entry
  has_one_attached :profile_picture
  attribute :new_profile_picture
  attribute :remove_profile_picture, :boolean

  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :profile, length: { maximum: 160 }
  validate if: :new_profile_picture do
    if new_profile_picture.respond_to?(:content_type)
      unless new_profile_picture.content_type.in?(ALLOWED_CONTENT_TYPES)
        errors.add(:new_profile_picture, :invalid_image_type)
      end
    else
      errors.add(:new_profile_picture, :invalid)
    end
  end

  def Member.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                              BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def Member.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = Member.new_token
    update_attribute(:remember_digest, Member.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  before_save do
    if new_profile_picture
      self.profile_picture = new_profile_picture
    elsif remove_profile_picture
      self.profile_picture.purge
    end
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    MemberMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = Member.new_token
    update_attribute(:reset_digest, Member.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    MemberMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def votable_for?(entry)
    entry && entry.author != self && !votes.exists?(entry_id: entry.id)
  end

  def follow(other_member)
    following << other_member
  end

  def unfollow(other_member)
    active_relationships.find_by(followed_id: other_member.id).destroy
  end

  def following?(other_member)
    following.include?(other_member)
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token = Member.new_token
    self.activation_digest = Member.digest(activation_token)
  end
end
