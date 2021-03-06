require 'rails_helper'

RSpec.describe ComputersController, type: :controller do
  let!(:producer) { create(:producer) }
  let!(:producer2) { create(:producer2) }
  let!(:computer) { create(:computer) }
  let!(:computer2) { create(:computer2) }
  let!(:user) { create(:user) }

  context 'index' do
    it 'no parameters. Should return 2 computers' do
      get :index

      body = JSON(response.body)
      expect(response).to have_http_status(:ok)
      expect(body['data'].count).to eq(2)
      expect(body['items']).to eq(2)
      expect(body['pages']).to eq(1)
      expect(body['page']).to eq(1)
    end

    it 'page parameters. Should return 0 computers' do
      get :index, params: { page: 4 }

      body = JSON(response.body)
      expect(response).to have_http_status(:ok)
      expect(body['data'].count).to eq(0)
      expect(body['items']).to eq(0)
      expect(body['pages']).to eq(1)
      expect(body['page']).to eq(4)
    end

    it 'name parameter. Should return 1 computer' do
      get :index, params: { name: producer.name }

      body = JSON(response.body)
      expect(response).to have_http_status(:ok)
      expect(body['data'].count).to eq(1)
      expect(body['items']).to eq(1)
      expect(body['data'][0]['name']).to eq(computer.name)
      expect(body['data'][0]['price']).to eq(computer.price.to_s)
      expect(body['data'][0]['producer_id']).to eq(computer.producer_id)
    end

    it 'name parameter. Should return 2 computers' do
      get :index, params: { name: 's' }

      body = JSON(response.body)
      expect(response).to have_http_status(:ok)
      expect(body['data'].count).to eq(2)
      expect(body['items']).to eq(2)
      expect(body['page']).to eq(1)
    end

    it 'producer_name parameter. Should return 1 computer' do
      get :index, params: { name: producer.name }

      body = JSON(response.body)
      expect(response).to have_http_status(:ok)
      expect(body['data'].count).to eq(1)
      expect(body['items']).to eq(1)
      expect(body['data'][0]['producer_id']).to eq(producer.id)
    end

    it 'min_price parameter. Should return 1 computer' do
      get :index, params: { min_price: 1000 }

      body = JSON(response.body)
      expect(response).to have_http_status(:ok)
      expect(body['data'].count).to eq(1)
      expect(body['data'][0]['name']).to eq(computer2.name)
    end

    it 'min_price parameter. Should return 2 computers' do
      get :index, params: { min_price: 50 }

      body = JSON(response.body)
      expect(response).to have_http_status(:ok)
      expect(body['data'].count).to eq(2)
      expect(body['items']).to eq(2)
    end

    it 'max_price parameter. Should return 1 computer' do
      get :index, params: { max_price: 1000 }

      body = JSON(response.body)
      expect(response).to have_http_status(:ok)
      expect(body['data'].count).to eq(1)
      expect(body['data'][0]['name']).to eq(computer.name)
    end

    it 'max_price parameter. Should return 2 computers' do
      get :index, params: { max_price: 5000 }

      body = JSON(response.body)
      expect(response).to have_http_status(:ok)
      expect(body['data'].count).to eq(2)
      expect(body['items']).to eq(2)
    end

    it 'max_price parameter. Should return 0 computers' do
      get :index, params: { max_price: 50 }

      body = JSON(response.body)
      expect(response).to have_http_status(:ok)
      expect(body['data'].count).to eq(0)
      expect(body['items']).to eq(0)
      expect(body['pages']).to eq(0)
    end
  end

  context 'show' do
    it 'valid id. Should return computer' do
      get :show, params: { id: computer.id }

      body = JSON(response.body)
      expect(response).to have_http_status(:ok)
      expect(body['name']).to eq(computer.name)
      expect(body['price']).to eq(computer.price.to_s)
    end

    it 'invalid id. Should return an error' do
      get :show, params: { id: 'invalid id' }

      body = JSON(response.body)
      expect(response).to have_http_status(:not_found)
      expect(body['errors'].count).to eq(1)
      expect(body['errors'][0]).to eq('Computer with the given id does not exist.')
    end
  end

  context 'post' do
    let(:computer_params) { { name: 'new name', price: 123.0, producer_name: producer2.name } }

    it 'returns unauthorized - no key given' do
      expect do
        post :create, params: computer_params
      end.to change(Computer, :count).by(0)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized - invalid key' do
      expect do
        post :create, params: { **computer_params, key: 'invalid-key' }
      end.to change(Computer, :count).by(0)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'creates one computer and return it' do
      post :create, params: { **computer_params, key: user.key }

      body = JSON(response.body)
      expect(response).to have_http_status(:ok)
      expect(body['name']).to eq('new name')
      expect(body['price']).to eq(computer_params[:price].to_s)
      expect(body['producer_id']).to eq(producer2.id)

      expect(Computer.count).to eq(3)
      expect(Producer.count).to eq(2)
    end

    it 'creates one computer and one producer' do
      post :create, params: { name: computer.name, price: 100, producer_name: 'new producer', key: user.key }

      body = JSON(response.body)
      expect(response).to have_http_status(:ok)
      expect(body['name']).to eq(computer.name)

      expect(Computer.count).to eq(3)
      expect(Producer.count).to eq(3)
    end
  end

  context 'put #update' do
    let(:computer_params) { { id: computer.id, name: 'new name', price: 5 } }

    it 'returns unauthorized - no key given' do
      put :update, params: computer_params

      expect(response).to have_http_status(:unauthorized)
      expect(Computer.find(computer_params[:id]).name).not_to eq(computer_params[:name])
    end

    it 'returns unauthorized - invalid key' do
      put :update, params: { **computer_params, key: 'invalid-key' }

      expect(response).to have_http_status(:unauthorized)
      expect(Computer.find(computer_params[:id]).name).not_to eq(computer_params[:name])
    end

    it 'valid params. Should return updated computer' do
      put :update, params: { id: computer.id, name: 'new name', price: 5, key: user.key }

      body = JSON(response.body)
      expect(response).to have_http_status(:ok)
      expect(body['name']).to eq('new name')
      expect(body['price']).to eq(5.0.to_s)

      expect(Computer.count).to eq(2)
      expect(Producer.count).to eq(2)
    end

    it 'invalid price' do
      put :update, params: { id: computer2.id, price: -5, key: user.key }

      body = JSON(response.body)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(body['errors'].count).to eq(1)
      expect(body['errors'][0]).to eq('Price must be greater than 0')
    end

    it 'invalid id. Should return an error' do
      put :update, params: { id: 'invalid id', key: user.key }

      body = JSON(response.body)
      expect(response).to have_http_status(:not_found)
      expect(body['errors'].count).to eq(1)
      expect(body['errors'][0]).to eq('Computer with the given id does not exist.')
    end
  end

  context 'delete #destroy' do
    let(:computer_params) { { id: computer.id } }

    it 'returns unauthorized - no key given' do
      expect do
        post :destroy, params: computer_params
      end.to change(Computer, :count).by(0)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized - invalid key' do
      expect do
        post :destroy, params: { **computer_params, key: 'invalid-key' }
      end.to change(Computer, :count).by(0)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'valid id. Should destroy one computer' do
      expect do
        delete :destroy, params: { id: computer.id, key: user.key }
      end.to change(Computer, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end

    it 'invalid id. Should return an error' do
      expect do
        delete :destroy, params: { id: 'invalid id', key: user.key }
      end.to change(Computer, :count).by(0)

      expect(response).to have_http_status(:not_found)
    end
  end
end
