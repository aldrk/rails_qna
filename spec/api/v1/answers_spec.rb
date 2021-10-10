describe 'Answers API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json',
                    'ACCEPT' => 'application/json' } }
  let(:headers_with_params) { {  'CONTENT_TYPE' => 'application/x-www-form-urlencoded',
                                 'ACCEPT' => 'application/json' } }
  let(:delete_headers) { {  'ACCEPT' => 'application/json' } }


  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body author_id created_at updated_at links files_url comments].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
      let(:headers) { { 'ACCEPT' => 'application/json' } }
    end

    context 'authorized' do
      let(:user) { create(:user, admin: true) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:answer_response) { json['answer'] }

      before do
        delete api_path, params: { access_token: access_token.token }, headers: delete_headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'return deleted answer' do
        %w[id title body].each do |attr|
          expect(answer_response[attr]).to eq answer[attr.to_sym]
        end
      end
    end
  end

  describe 'POST /api/v1/answers/' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:headers) { { 'CONTENT_TYPE' => 'application/x-www-form-urlencoded',
                        'ACCEPT' => 'application/json' } }
    end

    context 'authorized' do
      let(:user) { create(:user, admin: true) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:answer_response) { json['answer'] }
      let(:answer_params) { attributes_for(:answer) }

      before { post api_path, params: { access_token: access_token.token, answer: answer_params }, headers: headers_with_params }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'return created answer' do
        %w[title body].each do |attr|
          expect(answer_response[attr]).to eq answer_params[attr.to_sym]
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/' do
    let(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
      let(:headers) { { 'CONTENT_TYPE' => 'application/x-www-form-urlencoded',
                        'ACCEPT' => 'application/json' } }
    end

    context 'authorized' do
      let(:user) { create(:user, admin: true) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:answer_response) { json['answer'] }

      before do
        answer.update(title: 'NewTitle')
        patch api_path, params: { access_token: access_token.token, answer: { id: answer.id, title: 'NewTitle'} }, headers: headers_with_params
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'return updated answer' do
        %w[id title body].each do |attr|
          expect(answer_response[attr]).to eq answer[attr.to_sym]
        end
      end
    end
  end
end