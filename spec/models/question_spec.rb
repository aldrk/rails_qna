require 'rails_helper'

RSpec.describe Question, type: :model do
  it { is_expected.to belong_to :author }

  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:links).dependent(:destroy) }

  it { is_expected.to have_one(:achievement).dependent(:destroy) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to accept_nested_attributes_for :links }

  it 'has one attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#best_answer' do
    let(:question) { create(:question) }

    context 'when question has a best answer' do
      let!(:answer) { create(:answer, question: question, best: true) }

      it { expect(question.best_answer.id).to be answer.id }
    end

    context 'when question has not a best answer' do
      let(:answer) { create(:answer, question: question) }

      it { expect(question.best_answer).to be_nil }
    end
  end
end
