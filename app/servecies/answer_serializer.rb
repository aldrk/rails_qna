class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :author_id

  has_many :comments
  has_many :links

  has_many :files, key: :files_url do
    object.files.map do |file|
      file.url
    end
  end
end