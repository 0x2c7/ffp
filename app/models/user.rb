class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar
  has_one_attached :cover

  has_many :posts, dependent: :destroy

  has_many :friendships
  has_many :friends, through: :friendships, class_name: 'User', foreign_key: :user_id
end
