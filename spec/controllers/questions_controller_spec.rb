RSpec.describe QuestionsController, type: :controller do
  describe 'GET #new' do
    let(:user) { create(:user) }

    before { login(user) }

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new link for question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns a new achievement for question' do
      expect(assigns(:question).achievement).to be_a_new(Achievement)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    before { login(user) }

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new Answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:post_create) { post :create, params: { question: question_params }, format: :js }

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
          expect(response).to have_http_status(:found)
        end
      end

      context 'with invalid attributes' do
        let(:question_params) { attributes_for(:question, :invalid) }

        it 'does not save the question' do
          expect { post_create }.not_to change(Question, :count)
        end

        it 're-render create view' do
          post_create
          expect(response).to render_template :create
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
        expect(response).to redirect_to "#{new_user_session_path}.js"
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_destroy) { delete :destroy, params: { id: question }, format: :js }

    context 'when authenticated user' do
      let(:user) { create(:user) }
      let!(:question) { create(:question, author: user) }

      before { login(user) }

      it 'destroys the question' do
        expect { delete_destroy }.to change(Question, :count).by(-1)
      end

      it 'render destroy template' do
        delete_destroy
        expect(response).to render_template :destroy
      end
    end

    context 'when unauthenticated user' do
      let(:user) { create(:user) }
      let!(:question) { create(:question, author: user) }

      it 'destroys the question' do
        expect { delete_destroy }.not_to change(Question, :count)
      end

      it 'redirect to sign in' do
        delete_destroy
        expect(response).to redirect_to "#{new_user_session_path}.js"
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'PATCH #update' do
    let(:patch_update) { patch :update, params: { id: question, question: question_params }, format: :js }

    context 'when authenticated user' do
      let(:user) { create(:user) }
      let!(:question) { create(:question, author: user) }

      before { login(user) }

      context 'with valid attributes' do
        let(:question_params) { attributes_for(:question, body: 'new body') }

        it 'changes question attributes' do
          patch_update
          question.reload
          expect(question.body).to eq 'new body'
        end

        it 'renders update view' do
          patch_update
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        let(:question_params) { attributes_for(:question, :invalid) }

        it 'does not change question attributes' do
          expect { patch_update }.not_to change(question, :body)
        end

        it 'renders update view' do
          patch_update
          expect(response).to render_template :update
        end
      end
    end

    context 'when unauthenticated user' do
      let!(:question) { create(:question) }
      let(:question_params) { attributes_for(:question, body: 'new body') }

      it 'does not see question attributes' do
        expect { patch_update }.not_to change(question, :body)
      end

      it 'redirect to sign in' do
        patch_update
        expect(response).to redirect_to "#{new_user_session_path}.js"
        expect(response).to have_http_status(:found)
      end
    end
  end
end
