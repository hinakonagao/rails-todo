class Task < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :finished, inclusion: { in: [true, false] }
end
