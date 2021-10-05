class Comment < ApplicationRecord
  belongs_to :author, foreign_key: 'author_id', class_name: 'User'
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true
end
