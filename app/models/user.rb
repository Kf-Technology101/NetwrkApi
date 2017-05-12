class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable#, :validatable

  # validates_presence_of :phone
  # validates_presence_of :first_name
  # validates_presence_of :last_name
  validates_uniqueness_of :phone
  validates_uniqueness_of :email

  has_many :posts
  # has_and_belongs_to_many :networks
  has_many :networks_users, dependent: :destroy
  has_many :networks, through: :networks_users

  #
  has_many :deleted_messages
  has_many :messages_deleted, through: :deleted_messages, class_name: 'Message'

  has_many :user_likes
  has_many :liked_messages, through: :user_likes, class_name: 'Message'

  has_many :legendary_likes
  has_many :legendary_messages, through: :legendary_likes, class_name: 'Message'

  has_many :providers, dependent: :destroy

  before_create :generate_authentication_token!

  enum gender: %i[male female]

  has_attached_file :avatar, styles: { medium: "256x256#", thumb: "100x100>" }, default_url: "/images/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  has_attached_file :hero_avatar, styles: { medium: "256x256#", thumb: "100x100>" }, default_url: "/images/missing.png"
  validates_attachment_content_type :hero_avatar, content_type: /\Aimage\/.*\z/

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end

  def connected_networks
    providers.pluck(:name)
  end

  def avatar_url
    ActionController::Base.helpers.asset_path(avatar.url(:medium))
  end

  def hero_avatar_url
    hero_avatar.present? ? (ActionController::Base.helpers.asset_path(hero_avatar.url(:medium))) : role_image_url
  end

  def able_to_post_legendary?
    legendary_at.nil? || legendary_days >= 30
  end

  def legendary_days
    (DateTime.now.to_date - legendary_at.to_date).to_i
  end

  def log_in_count
    sign_in_count
  end
end
