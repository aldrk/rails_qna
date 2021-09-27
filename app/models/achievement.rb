class Achievement < ApplicationRecord
  has_one_attached :image

  belongs_to :question
  belongs_to :user, optional: true

  def achieve(user)
    update!(user: user)
  end
end