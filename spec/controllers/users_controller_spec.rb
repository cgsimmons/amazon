require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe '#new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
    it 'sets an instance variable of User type' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end
  describe '#create' do
    def valid_request
      post :create,
      params: {user: attributes_for(:user)}
    end
    context 'with valid params'do
      it 'created a user in DB' do
        before_count = User.count
        valid_request
        after_count = User.count
        expect(after_count).to eq(before_count + 1)
      end
      it 'redirects to home page' do
        valid_request
        expect(response).to redirect_to(root_path)
      end
      it 'signs the user in' do
        valid_request
        expect(session[:user_id]).to be
      end
    end

    context 'without valid params' do
      def invalid_request
        post :create, params: {user: {first_name: nil}}
      end
      it 'renders the new template' do
        invalid_request
        expect(response).to render_template(:new)
      end
      it 'doesn\'t create a user in the DB' do
        before_count = User.count
        invalid_request
        after_count = User.count
        expect(after_count).to eq(before_count)
      end
    end
  end

end
