class User < ApplicationRecord
  has_secure_password # 仮想的な属性passwordとpassword_confirmationが使えるようになる

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true
  validates :password, presence: true, length: { minimum: 4 }
end
