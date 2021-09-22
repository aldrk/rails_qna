class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, foreign_key: 'author_id', class_name: 'User'

  validates :title, :body, presence: true

  def choose_best_answer
    transaction do
      best_answer = question.best_answer
      best_answer.update!(best: false) if best_answer
      update!(best: true)
    end
  end
end