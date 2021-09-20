RSpec.describe QuestionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:post_create) { post :create, params: { question: question_params } }

    context 'when authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        let(:question_params) { attributes_for(:question) }

        it 'saves a new question in the database' do
          expect { post_create }.to change(Question, :count).by(1)
        end

        it 'redirects to show view' do
          post_create
          expect(response).to redirect_to assigns(:question)
          expect(response).to have_http_status(302)
        end
      end

      context 'with invalid attributes' do
        let(:question_params) { attributes_for(:question, :invalid) }

        it 'does not save the question' do
          expect { post_create }.not_to change(Question, :count)
        end

        it 're-render new view' do
          post_create
          expect(response).to render_template :new
        end
      end
    end

    context 'when unauthenticated user' do
      let(:question_params) { attributes_for(:question) }

      it 'saves a new question in the database' do
        expect { post_create }.not_to change(Question, :count)
      end

      it 'redirect to sign in' do
        post_create
        expect(response).to redirect_to new_user_session_path
        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_destroy) { delete :destroy, params: { id: question } }

    context 'when authenticated user' do
      let(:user) { create(:user) }
      let!(:question) { create(:question, author: user) }

      before { login(user) }

      it 'destroys the question' do
        expect { delete_destroy }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete_destroy
        expect(response).to redirect_to root_path
      end
    end

    context 'when unauthenticated user' do
      let(:user) { create(:user) }
      let!(:question) { create(:question, author: user) }

      it 'destroys the question' do
        expect { delete_destroy }.not_to change(Question, :count)
      end

      it 'redirects to index' do
        delete_destroy
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
