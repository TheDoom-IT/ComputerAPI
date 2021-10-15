require 'rails_helper'

RSpec.describe ProducersController, type: :controller do

  let!(:producer) { create(:producer) }
  let!(:producer2) { create(:producer2) }

  context 'index' do
    it 'no parameters. Should return two producers' do
      get :index

      body = JSON(response.body)
      expect(response).to have_http_status(:ok)
      expect(body['data'].count).to eq(2)
      expect(body['items']).to eq(2)
      expect(body['page']).to eq(1)
      expect(body['pages']).to eq(1)
    end

    it 'page parameter. Should return zero producers' do
      get :index, params: { page: 5 }

      body = JSON(response.body)
      expect(response).to have_http_status(:ok)
      expect(body['data'].count).to eq(0)
      expect(body['items']).to eq(0)
      expect(body['page']).to eq(5)
      expect(body['pages']).to eq(1)
    end

    it 'name parameter. Should return one producer' do
      get :index, params: { name: producer2.name }

      body = JSON(response.body)
      expect(response).to have_http_status(:ok)
      expect(body['data'].count).to eq(1)
      expect(body['items']).to eq(1)
      expect(body['page']).to eq(1)
      expect(body['pages']).to eq(1)
      expect(body['data'][0]['description']).to eq(producer2.description)
    end

    it 'description parameter. Should return one producer' do
      get :index, params: { description: producer.description }

      body = JSON(response.body)
      expect(response).to have_http_status(:ok)
      expect(body['data'].count).to eq(1)
      expect(body['items']).to eq(1)
      expect(body['page']).to eq(1)
      expect(body['pages']).to eq(1)
      expect(body['data'][0]['name']).to eq(producer.name)

    end

    it 'description parameter. Should return two producers' do
      get :index, params: { description: 'c' }

      body = JSON(response.body)
      expect(response).to have_http_status(:ok)
      expect(body['data'].count).to eq(2)
      expect(body['items']).to eq(2)
      expect(body['page']).to eq(1)
      expect(body['pages']).to eq(1)
    end
  end

  context 'show' do
    it 'wrong id. Should return zero producers' do
      get :show, params: { id: 'wrongId' }

      expect(response).to have_http_status(:not_found)
    end

    it 'good id. Should return first producer' do
      get :show, params: { id: producer.id }

      expect(response).to have_http_status(:ok)
      expect(JSON(response.body)).to eq(JSON(producer.to_json))
    end

    it 'good id. Should return second producer' do
      get :show, params: { id: producer2.id }

      expect(response).to have_http_status(:ok)
      expect(JSON(response.body)).to eq(JSON(producer2.to_json))
    end
  end

  context 'create' do
    it 'should create one producer and return it' do
      post :create, params: { name: 'new name', description: 'description' }

      expect(response).to have_http_status(:ok)
      expect(JSON(response.body)['name']).to eq('new name')
      expect(JSON(response.body)['description']).to eq('description')

      # try to get freshly created producer
      get :show, params: { id: JSON(response.body)['id'] }
      expect(response).to have_http_status(:ok)
      expect(JSON(response.body)['name']).to eq('new name')
      expect(JSON(response.body)['description']).to eq('description')
    end

    it 'should not create new producer. Name is already taken' do
      post :create, params: { name: producer.name, description: producer.description }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON(response.body)['errors'][0]).to eq('Name has already been taken')
    end
  end

  context 'update' do
    it 'should update first producer' do
      put :update, params: { id: producer.id, name: 'new name', description: 'new description' }

      expect(response).to have_http_status(:ok)
      expect(JSON(response.body)['name']).to eq('new name')
      expect(JSON(response.body)['description']).to eq('new description')

      # try to get updated producer
      get :show, params: { id: producer.id }
      expect(response).to have_http_status(:ok)
      expect(JSON(response.body)['name']).to eq('new name')
      expect(JSON(response.body)['description']).to eq('new description')
    end

    it 'should not update producer. Invalid id' do
      put :update, params: { id: 'invalid id', name: 'new name', description: 'new description' }

      expect(response).to have_http_status(:not_found)
      expect(JSON(response.body)['errors'][0]).to eq('Producer with the given id does not exist.')
    end
  end

  context 'destroy' do
    it 'should delete first producer' do
      delete :destroy, params: { id: producer2.id }
      expect(response).to have_http_status(:ok)

      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON(response.body)['data'].count).to eq(1)

      get :show, params: { id: producer2.id }
      expect(response).to have_http_status(:not_found)
    end

    it 'should not delete producer. Invalid id' do
      delete :destroy, params: { id: 'invalid id' }
      expect(response).to have_http_status(:not_found)

      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON(response.body)['data'].count).to eq(2)
    end
  end
end
