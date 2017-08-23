require 'rails_helper'

describe TerminalsController do
  let(:tenant) { create(:tenant) }

  describe 'set tenant' do
    context 'when organization exists' do

      it 'assigns tenant' do
        get :index, params: { organization: tenant.organization }
        expect(response).to have_http_status(200)
      end
    end

    context 'when organization does not exist' do
      it 'redirects to root' do
        get :index, params: { organization: 'foobar' }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET index' do
    it 'shows terminals list' do
      get :index, params: { organization: tenant.organization }
      expect(response).to be_success
      expect(response).to render_template('terminals/index')
    end
  end

  describe 'GET new' do
    it 'shows new terminal form' do
      get :new, params: { organization: tenant.organization }

      expect(response).to be_success
      expect(response).to render_template('terminals/new')
    end
  end

  describe 'POST create' do
    context 'when data is valid' do
      it 'creates a terminal' do
        expect do
          post :create, params: {
                          organization: tenant.organization,
                          terminal: { name: 'foobar' }
                        }
        end.to change { Terminal.count }.by(1)

        expect(response).to redirect_to(terminals_path(tenant.organization))
      end
    end

    context 'when data is invalid' do
      it 'shows error list' do
        expect do
          post :create, params: {
                          organization: tenant.organization,
                          terminal: { name: '' }
                        }
        end.to change { Terminal.count }.by(0)

        expect(response).to render_template('terminals/new')
      end
    end
  end

  describe 'GET show' do
    context 'when terminal is found' do
      let(:terminal) { create(:terminal, tenant_id: tenant.id) }

      before do
        ActsAsTenant.current_tenant = tenant
      end

      after do
        ActsAsTenant.current_tenant = nil
      end

      it 'shows the terminal' do
        get :show, params: { organization: tenant.organization,
                              id: terminal.id }

        expect(response).to be_success
        expect(response).to render_template('terminals/show')
      end
    end

    context 'when terminal is not found' do
      it 'redirects to terminals with flash' do
        get :show, params: { organization: tenant.organization, id: 'foobar' }

        expect(response).to redirect_to(terminals_path(tenant.organization))
        expect(flash[:message]).to match(/La terminal no existe/)
      end
    end
  end

  describe 'GET edit' do
    context 'when terminal is found' do
      let(:terminal) { create(:terminal, tenant_id: tenant.id) }

      before do
        ActsAsTenant.current_tenant = tenant
      end

      after do
        ActsAsTenant.current_tenant = nil
      end

      it 'shows edit form' do
        get :edit, params: { organization: tenant.organization, id: terminal.id }

        expect(response).to be_success
        expect(response).to render_template('terminals/edit')
      end
    end

    context 'when terminal is not found' do
      it 'redirects to terminals with flash' do
        get :edit, params: { organization: tenant.organization, id: 'foobar' }

        expect(response).to redirect_to(terminals_path(tenant.organization))
        expect(flash[:message]).to match(/La terminal no existe/)
      end
    end
  end

  describe 'UPDATE' do
    before do
      ActsAsTenant.current_tenant = tenant
    end

    after do
      ActsAsTenant.current_tenant = nil
    end

    context 'when terminal is found' do
      let(:terminal) { create(:terminal, tenant_id: tenant.id) }


      it 'updates terminal' do
        patch :update, params: { organization: tenant.organization,
                                  terminal: { name: 'foobar' },
                                  id: terminal.id }

        terminal.reload
        expect(terminal.name).to eq('foobar')
        expect(response).to redirect_to(terminal_path(terminal))
        expect(flash[:message]).to match(/Actualizado correctamente./)
      end
    end

    context 'when invalid data' do
      let(:terminal) { create(:terminal, tenant_id: tenant.id) }

      it 'shows errors with flash' do
        patch :update, params: { organization: tenant.organization,
                                  terminal: { name: '' },
                                  id: terminal.id }

        expect(response).to render_template 'terminals/edit'
      end
    end

    context 'when terminal is not found' do
      it 'redirects to terminals with flash' do
        patch :update, params: { organization: tenant.organization,
                                  id: 'foobar' }

        expect(response).to redirect_to(terminals_path)
        expect(flash[:message]).to match(/La terminal no existe/)
      end
    end
  end

  describe 'DELETE' do
    before do
      ActsAsTenant.current_tenant = tenant
    end

    after do
      ActsAsTenant.current_tenant = nil
    end

    context 'when terminal is found' do
      it 'redirects to terminals with flash' do
        terminal = create(:terminal)
        expect do
          delete :destroy, params: { organization: tenant.organization,
                                    id: terminal.id }
        end.to change { Terminal.count }.by(-1)

        expect(response).to redirect_to(terminals_path(tenant.organization))
        expect(flash[:message]).to match(/La terminal ha sido eliminada/)
      end
    end

    context 'when terminal is not found' do
      it 'redirects to terminals with flash' do
        expect do
          delete :destroy, params: { organization: tenant.organization,
                                    id: 'foobar' }
        end.to change { Terminal.count }.by(0)

        expect(response).to redirect_to(terminals_path(tenant.organization))
        expect(flash[:message]).to match(/La terminal no existe/)
      end
    end
  end

  describe 'POST send_token' do
    let(:terminal) { create(:terminal, tenant_id: tenant.id) }

    before do
      ActsAsTenant.current_tenant = tenant
    end

    after do
      ActsAsTenant.current_tenant = nil
    end

    def go(id, email = 'foo@bar.com')
      post :send_token, params: { organization: tenant.organization,
                                  device_email: { email: email },
                                  id: id }
    end

    context 'when terminal is found' do

      it 'redirects to terminal with flash' do
        go(terminal.id)
        expect(response).to redirect_to(terminal_path(terminal))
      end

      it 'flashes success message' do
        go(terminal.id)
        expect(flash[:message]).to eq("Enviado instrucciones a <strong>foo@bar.com</strong>.")
      end

      it 'sends email' do
        go(terminal.id)
        expect(last_email.to).to include('foo@bar.com')
      end
    end

    context 'when terminal is not found' do
      it 'shows flash message' do
        go('foobar')

        expect(flash[:message]).to match(/La terminal no existe/)
        expect(response).to redirect_to(terminals_path(tenant.organization))
      end

      it 'does not send email' do
        go('foobar')

        expect(last_email).to be_nil
      end
    end

    context 'when email is invalid' do
      it 'shows flash message' do
        go(terminal.id, '')

        expect(flash[:type]).to eq('danger')
        expect(flash[:message]).to match(/No se ha podido enviar el correo./)
        expect(response).to render_template('terminals/show')
      end

      it 'does not send email' do
        go(terminal.id, '')

        expect(last_email).to be_nil
      end
    end
  end

  describe 'DELETE pair_device' do
    let(:terminal) { create(:terminal, tenant_id: tenant.id) }
    let(:device) { create(:device, terminal_id: terminal.id, current: true) }

    before do
      ActsAsTenant.current_tenant = tenant
    end

    after do
      ActsAsTenant.current_tenant = nil
    end

    def go(id)
      delete :unpair_device, params: { organization: tenant.organization,
                                      id: id }
    end

    context 'when device is found' do
      it 'redirects to terminal' do
        go(terminal.id)

        expect(response).to redirect_to(terminal_path(tenant.organization, terminal))
      end

      it 'resets terminal' do
        go(terminal.id)

        terminal.reload
        expect(terminal.paired).to be_falsey
        expect(terminal.pairing_token).not_to be_nil
        expect(terminal.access_token).to be_nil
      end
    end

    context 'when device is not found' do
      it 'redirects to terminal with flash' do
        go('foobar')

        expect(response).to redirect_to(terminals_path(tenant.organization))
        expect(flash[:message]).to match(/La terminal no existe/)
      end
    end
  end
end
