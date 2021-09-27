class Question < ApplicationRecord
  belongs_to :author, foreign_key: 'author_id', class_name: 'User'

  has_many :answers, dependent: :destroy

  has_many :links, dependent: :destroy, as: :linkable

  has_one :achievement, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, :achievement, reject_if: :all_blank

  validates :title, :body, presence: true

  def best_answer
    answers.find_by_best(true)
  end

  def new_best_answer(answer)
    transaction do
      if best_answer
        best_answer.update!(best: false)
      end

      answer.update!(best: true)
    end
  end
end
