RSpec.describe LinksController, type: :controller do
  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:question) { create(:answer, author: user) }
    let(:delete_destroy) { delete :destroy, params: { id: link }, format: :js }

    context 'when authenticated user' do
      let!(:link) { create(:link, linkable: question) }

      before { login(user) }

      it 'deletes the link attached to answer' do
        expect { delete_destroy }.to change(Link, :count).by(-1)
      end

      it 'render destroy view' do
        delete_destroy
        expect(response).to render_template :destroy
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when unauthenticated user' do
      let!(:link) { create(:link, linkable: question) }

      it 'not deletes the file attached to answer' do
        expect { delete_destroy }.to change(Link, :count).by(0)
      end

      it 'redirect to sign in' do
        delete_destroy
        expect(response).to redirect_to "#{new_user_session_path}.js"
        expect(response).to have_http_status(:found)
      end
    end
  end
end
