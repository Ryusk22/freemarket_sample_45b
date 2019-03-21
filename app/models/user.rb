class User < ApplicationRecord

  devise  :omniauthable,
          :database_authenticatable,
          :registerable,
          :recoverable,
          :rememberable,
          :validatable,
          omniauth_providers: %i[facebook google_oauth2]


  validates :nickname, presence: true

  has_one :profile
  has_many :products
  has_one :users
  has_many :sns_credentials
  has_many :likes
  has_many :products, through: :likes
  has_many :trades
  has_many :comments

  def already_liked?(product)
    self.likes.exists?(product_id: product.id)
  end

  def self.create_oauth(auth)
  user = User.create(
    nickname: auth.info.name,
    email:    auth.info.email,
    password: Devise.friendly_token[0, 20]
    )
  SnsCredential.create(
    uid: auth.uid,
    provider: auth.provider,
    user_id: user.id
    )
  return user
  end
end
