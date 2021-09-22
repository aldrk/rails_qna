RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:post_create) { post :create, params: { answer: answer_params, question_id: question.id }, format: :js }

    context 'when authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        let(:answer_params) { attributes_for(:answer) }

        it 'saves a new answer in database' do
          expect { post_create }.to change(Answer, :count).by(1)
        end

        it 'renders create view' do
          post_create
          expect(response).to render_template :create
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid attributes' do
        let(:answer_params) { attributes_for(:answer, :invalid) }

        it 'does not save the answer' do
          expect { post_create }.not_to change(Answer, :count)
        end

        it 're-render create view' do
          post_create
          expect(response).to render_template :create
        end
      end
    end

    context 'when unauthenticated user' do
      let(:answer_params) { attributes_for(:answer) }

      it 'not saves a new answer in database' do
        expect { post_create }.not_to change(Answer, :count)
      end

      it 'redirects to sign in' do
        post_create
        expect(response).to redirect_to "#{new_user_session_path}.js"
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_destroy) { delete :destroy, params: { id: answer }, format: :js }

    context 'when authenticated user' do
      let(:user) { create(:user) }
      let!(:answer) { create(:answer, author: user) }

      before { login(user) }

      it 'destroys the answer' do
        expect { delete_destroy }.to change(Answer, :count).by(-1)
      end

      it 'redirects to index' do
        delete_destroy
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'when unauthenticated user' do
      let!(:answer) { create(:answer) }

      it 'not destroys the answer' do
        expect { delete_destroy }.not_to change(Answer, :count)
      end

      it 'redirects to sign in' do
        delete_destroy

        expect(response).to redirect_to "#{new_user_session_path}.js"
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'PATCH #update' do
    let(:patch_update) { patch :update, params: { id: answer, answer: answer_params }, format: :js }

    context 'when authenticated user' do
      let(:user) { create(:user) }
      let!(:answer) { create(:answer, author: user) }

      before { login(user) }

      context 'with valid attributes' do
        let(:answer_params) { attributes_for(:answer, body: 'new body') }

        it 'changes answer attributes' do
          patch_update
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch_update
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        let(:answer_params) { attributes_for(:answer, :invalid) }

        it 'does not change answer attributes' do
          expect { patch_update }.not_to change(answer, :body)
        end

        it 'renders update view' do
          patch_update
          expect(response).to render_template :update
        end
      end
    end

    context 'when unauthenticated user' do
      let!(:answer) { create(:answer) }
      let(:answer_params) { attributes_for(:answer, body: 'new body') }

      it 'does not see answer attributes' do
        expect { patch_update }.not_to change(answer, :body)
      end

      it 'redirects to sign in' do
        patch_update
        expect(response).to redirect_to "#{new_user_session_path}.js"
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'PATCH #nominate' do
    let(:patch_nominate) { patch :nominate, params: { id: answer }, format: :js }

    context 'when authenticated user' do
      let(:user) { create(:user) }
      let(:question) { create(:question, author: user) }
      let!(:answer) { create(:answer, question: question) }
      let!(:best_answer) { create(:answer, question: question, best: true) }

      before { login(user) }

      it 'change best answer' do
        patch_nominate
        expect { answer.reload }.to change(answer, :best)
      end

      it 'renders nominate view' do
        patch_nominate
        expect(response).to render_template :nominate
      end
    end

    context 'when unauthenticated user' do
      let(:user) { create(:user) }
      let(:question) { create(:question, author: user) }
      let!(:answer) { create(:answer, question: question) }
      let!(:best_answer) { create(:answer, question: question, best: true) }

      it 'does not see answer attributes' do
        patch_nominate
        expect { answer.reload }.not_to change(answer, :best)
      end

      it 'redirect to sign in' do
        patch_nominate
        expect(response).to redirect_to "#{new_user_session_path}.js"
        expect(response).to have_http_status(:found)
      end
    end
  end
end