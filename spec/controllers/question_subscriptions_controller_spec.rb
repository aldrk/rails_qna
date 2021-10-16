RSpec.describe QuestionSubscriptionsController, type: :controller do
  describe 'POST #subscribe' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:post_subscribe) { post :subscribe, params: { question_id: question.id } }

    context 'when authenticated user' do
      before { login(user) }

      it 'subscribing to question' do
        expect { post_subscribe }.to change(QuestionSubscription, :count).by(1)
      end

      it 'redirect to root path' do
        post_subscribe
        expect(response).to redirect_to root_path
        expect(response).to have_http_status(:found)
      end
    end

    context 'when unauthenticated user' do
      it 'subscribing to question' do
        expect { post_subscribe }.not_to change(QuestionSubscription, :count)
      end

      it 'redirect to root path' do
        post_subscribe
        expect(response).to redirect_to new_user_session_path
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'DELETE #unsubscribe' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:delete_unsubscribe) { delete :unsubscribe, params: { question_id: question.id } }

    before { create(:question_subscription, question: question, user: user) }

    context 'when authenticated user' do
      before { login(user) }

      it 'subscribing to question' do
        expect { delete_unsubscribe }.to change(QuestionSubscription, :count).by(-1)
      end

      it 'redirect to root path' do
        delete_unsubscribe
        expect(response).to redirect_to root_path
        expect(response).to have_http_status(:found)
      end
    end

    context 'when unauthenticated user' do
      it 'subscribing to question' do
        expect { delete_unsubscribe }.not_to change(QuestionSubscription, :count)
      end

      it 'redirect to root path' do
        delete_unsubscribe
        expect(response).to redirect_to new_user_session_path
        expect(response).to have_http_status(:found)
      end
    end
  end
end