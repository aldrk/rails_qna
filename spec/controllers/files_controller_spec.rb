RSpec.describe FilesController, type: :controller do
  describe 'DELETE #answer_destroy' do
    let(:user) { create(:user) }
    let!(:answer) { create(:answer, :with_files, author: user) }
    let(:delete_answer_destroy) { delete :answer_destroy, params: { file_id: answer.files.attachments[0].id }, format: :js }

    context 'when authenticated user' do
      before { login(user) }

      it 'deletes the file attached to answer' do
        expect { delete_answer_destroy }.to change{ ActiveStorage::Attachment.count }.by(-1)
      end

      it 'render answer_destroy view' do
        delete_answer_destroy
        expect(response).to render_template :answer_destroy
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when unauthenticated user' do
      it 'not deletes the file attached to answer' do
        expect { delete_answer_destroy }.to change{ ActiveStorage::Attachment.count }.by(0)
      end

      it 'redirect to sign in' do
        delete_answer_destroy
        expect(response).to redirect_to "#{new_user_session_path}.js"
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'DELETE #question_destroy' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, :with_files, author: user) }
    let(:delete_question_destroy) { delete :question_destroy, params: { file_id: question.files.attachments[0].id }, format: :js }

    context 'when authenticated user' do
      before { login(user) }

      it 'destroys the file attached to question' do
        expect { delete_question_destroy }.to change{ ActiveStorage::Attachment.count }.by(-1)
      end

      it 'renders question_destroy view' do
        delete_question_destroy
        expect(response).to render_template :question_destroy
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when unauthenticated user' do
      it 'not destroys the file attached to question' do
        expect { delete_question_destroy }.to change{ ActiveStorage::Attachment.count }.by(0)
      end

      it 'redirects to sign in' do
        delete_question_destroy
        expect(response).to redirect_to "#{new_user_session_path}.js"
        expect(response).to have_http_status(:found)
      end
    end
  end
end
