require 'rails_helper'

describe Users::RegistrationsController do

  describe 'POST create' do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = {
        email: 'foobar@mail.com',
        password: 'password',
        password_confirmation: 'password',
        tenant_attributes: {
          name: 'Foobar Inc.',
          organization: 'foobar'
        }
      }
    end

    def go
      post :create, params: { user: @user }
    end

    context 'when logged out' do
      before do
        ActsAsTenant.current_tenant = nil
      end

      context 'when is valid' do
        it 'redirects to root' do
          go
          expect(response).to redirect_to(root_path)
        end

        it 'creates user' do
          expect do
            go
          end.to change { User.count }.by(1)
        end

        it 'creates tenant' do
          expect do
            go
          end.to change { Tenant.count }.by(1)
        end
      end
    end

    context 'when logged in' do
      it 'redirects to root' do
        sign_in create(:user, tenant_id: @tenant.id)
        go
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
