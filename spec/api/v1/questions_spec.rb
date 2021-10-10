describe 'Questions API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json',
                    'ACCEPT' => 'application/json' } }
  let(:headers_with_params) { {  'CONTENT_TYPE' => 'application/x-www-form-urlencoded',
                                 'ACCEPT' => 'application/json' } }
  let(:delete_headers) { {  'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body author_id created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body author_id created_at updated_at links files_url comments].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
      let(:headers) { { 'ACCEPT' => 'application/json' } }
    end

    context 'authorized' do
      let(:user) { create(:user, admin: true) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:question_response) { json['question'] }

      before do
        delete api_path, params: { access_token: access_token.token }, headers: delete_headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'return deleted question' do
        %w[id title body].each do |attr|
          expect(question_response[attr]).to eq question[attr.to_sym]
        end
      end
    end
  end

  describe 'POST /api/v1/questions/' do
    let(:api_path) { "/api/v1/questions/" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:headers) { { 'CONTENT_TYPE' => 'application/x-www-form-urlencoded',
                        'ACCEPT' => 'application/json' } }
    end

    context 'authorized' do
      let(:user) { create(:user, admin: true) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:question_response) { json['question'] }
      let(:question_params) { attributes_for(:question) }

      before { post api_path, params: { access_token: access_token.token, question: question_params }, headers: headers_with_params }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'return created question' do
        %w[title body].each do |attr|
          expect(question_response[attr]).to eq question_params[attr.to_sym]
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
      let(:headers) { { 'CONTENT_TYPE' => 'application/x-www-form-urlencoded',
                        'ACCEPT' => 'application/json' } }
    end

    context 'authorized' do
      let(:user) { create(:user, admin: true) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:question_response) { json['question'] }

      before do
        question.update(title: 'NewTitle')
        patch api_path, params: { access_token: access_token.token, question: { id: question.id, title: 'NewTitle'} }, headers: headers_with_params
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'return updated question' do
        %w[id title body].each do |attr|
          expect(question_response[attr]).to eq question[attr.to_sym]
        end
      end
    end
  end
end