class Task < ApplicationRecord
  NOT_FINISHED = 0
  FINISHED = 1

  validates :title, presence: true, length: { maximum: 50 }
end
