class Answer < ApplicationRecord
  include Votable

  belongs_to :question
  belongs_to :author, foreign_key: 'author_id', class_name: 'User'

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, :body, presence: true

  def choose_best_answer
    transaction do
      best_answer = question.best_answer
      achievement = question.achievement

      achievement.achieve author if achievement
      best_answer.update!(best: false) if best_answer
      update!(best: true)
    end
  end
end