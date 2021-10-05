RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:post_create) { post :create, params: { comment: comment_params, question_id: question.id, commentable_type: 'Question' }, format: :js }

    context 'when authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        let(:comment_params) do
          comment = attributes_for(:comment)
          comment[:commentable] = question
          comment
        end

        it 'saves a new answer in database' do
          expect { post_create }.to change(Comment, :count).by(1)
        end

        it 'render create view' do
          post_create
          expect(response).to render_template :create
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid attributes' do
        let(:comment_params) { attributes_for(:comment, :invalid) }

        it 'does not save the comment' do
          expect { post_create }.not_to change(Comment, :count)
        end

        it 'render create view' do
          post_create
          expect(response).to render_template :create
        end
      end
    end

    context 'when unauthenticated user' do
      let(:comment_params) { attributes_for(:comment) }

      it 'not saves a new comment in database' do
        expect { post_create }.not_to change(Comment, :count)
      end

      it 'redirect to sign in' do
        post_create
        expect(response).to redirect_to new_user_session_path(format: :js)
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_destroy) { delete :destroy, params: { id: comment }, format: :js }

    context 'when authenticated user' do
      let(:user) { create(:user) }
      let!(:comment) { create(:comment, author: user) }

      before { login(user) }

      it 'deletes the answer' do
        expect { delete_destroy }.to change(Comment, :count).by(-1)
      end

      it 'render destroy template' do
        delete_destroy
        expect(response).to render_template :destroy
      end
    end

    context 'when unauthenticated user' do
      let!(:comment) { create(:comment) }

      it 'not deletes the answer' do
        expect { delete_destroy }.not_to change(Answer, :count)
      end

      it 'redirect to sign in' do
        delete_destroy
        expect(response).to redirect_to new_user_session_path(format: :js)
        expect(response).to have_http_status(:found)
      end
    end
  end
end
