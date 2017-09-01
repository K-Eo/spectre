require 'rails_helper'

describe TerminalsController do
  let(:user) { create(:user) }

  describe 'GET index' do
    context 'when logged in' do
      render_views

      subject do
        sign_in user
        get :index
        response
      end

      it { is_expected.to have_http_status(:success) }
      it { is_expected.to render_template('index') }

      it 'renders terminals' do
        create_list(:terminal, 2)
        sign_in user
        get :index
        expect(response.body).to have_css('li[id^=terminal_]', count: 2)
      end
    end

    context 'when logged out' do
      subject do
        get :index
        response
      end

      it { is_expected.to have_http_status(:found) }
      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

  describe 'GET new' do
    context 'when logged in' do
      subject do
        sign_in user
        get :new
        response
      end

      it { is_expected.to have_http_status(:success) }
      it { is_expected.to render_template('terminals/new') }
    end

    context 'when logged out' do
      subject do
        get :new
        response
      end

      it { is_expected.to have_http_status(:found) }
      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

  describe 'POST create' do
    context 'when logged in' do
      before do
        sign_in user
      end

      context 'when data is valid' do
        def go
          post :create, params: { terminal: attributes_for(:terminal) }
        end

        it 'creates a terminal' do
          expect do
            go
          end.to change { Terminal.count }.by(1)
        end

        it 'redirects to terminal' do
          go
          terminal = Terminal.last
          expect(response).to redirect_to(terminal_path(terminal))
        end
      end

      context 'when data is invalid' do
        def go
          post :create, params: { terminal: attributes_for(:terminal, name: '') }
        end

        it 'not creates terminal' do
          expect do
            go
          end.to change { Terminal.count }.by(0)
        end

        it 'renders new template' do
          go
          expect(response).to render_template('terminals/new')
        end
      end
    end

    context 'when logged out' do
      it 'redirects to sign in' do
        post :create, params: { terminal: attributes_for(:terminal) }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET show' do
    context 'when logged in' do
      before do
        sign_in user
      end

      context 'when terminal is found' do
        def go
          terminal = create(:terminal)
          get :show, params: { id: terminal.id }
        end

        it 'shows the terminal' do
          go
          expect(response).to have_http_status(:success)
          expect(response).to render_template('terminals/show')
        end

        context 'when is not paired' do
          it 'assigns device_email and qr_pairing_token' do
            go
            expect(assigns(:device_email)).to be_a(DeviceEmail)
          end
        end

        context 'when is paired' do
          it 'assigns device but device_email and qr_pairing_token' do
            terminal = create(:terminal)
            device = create(:device, terminal_id: terminal.id, current: true)
            terminal.set_current_device(device)
            get :show, params: { id: terminal.id }
            expect(assigns(:device_email)).to be_nil
            expect(assigns(:device)).to be_a(Device)
          end
        end
      end

      context 'when terminal is not found' do
        it 'redirects to not found' do
          get :show, params: { id: 'foobar' }
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when logged out' do
      it 'redirects to sign in' do
        get :show, params: { id: 'foobar' }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET edit' do
    context 'when logged in' do
      before do
        sign_in user
      end

      context 'when terminal is found' do
        let(:terminal) { create(:terminal) }

        it 'shows edit form' do
          get :edit, params: { id: terminal.id }
          expect(response).to have_http_status(:success)
          expect(response).to render_template('terminals/edit')
        end
      end

      context 'when terminal is not found' do
        it 'redirects to not found' do
          get :edit, params: { id: 'foobar' }
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when logged out' do
      it 'redirects to sign in' do
        get :edit, params: { id: 'foobar' }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'UPDATE' do
    context 'when logged in' do
      let(:terminal) { create(:terminal) }

      before do
        sign_in user
      end

      context 'when terminal is found' do
        def go
          patch :update, params: { terminal: { name: 'foobar' },
                                    id: terminal.id }
        end

        it 'updates terminal' do
          go
          terminal.reload
          expect(terminal.name).to eq('foobar')
        end

        it 'redirects back to terminal' do
          go
          expect(response).to redirect_to(terminal_path(terminal))
        end

        it 'sets flash message' do
          go
          expect(flash[:success]).to match(/Actualizado correctamente./)
        end
      end

      context 'when invalid data' do
        it 'renders edit template' do
          patch :update, params: { terminal: { name: '' },
                                    id: terminal.id }
          expect(response).to render_template 'terminals/edit'
        end
      end

      context 'when terminal is not found' do
        it 'redirects to not found' do
          patch :update, params: { id: 'foobar' }

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when logged out' do
      it 'redirects to sign in' do
        patch :update, params: { id: 'foobar' }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE' do
    context 'when logged in' do
      before do
        sign_in user
      end

      context 'when terminal is found' do
        def go
          terminal = create(:terminal)
          expect do
            delete :destroy, params: { id: terminal.id }
          end.to change { Terminal.count }.by(-1)
        end

        it 'redirects to terminals' do
          go
          expect(response).to redirect_to(terminals_path)
        end

        it 'sets flash' do
          go
          expect(flash[:success]).to match(/La terminal ha sido eliminada/)
        end
      end

      context 'when terminal is not found' do
        it 'redirects to not found' do
          expect do
            delete :destroy, params: { id: 'foobar' }
          end.to change { Terminal.count }.by(0)

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when logged out' do
      it 'redirects to sign in' do
        delete :destroy, params: { id: 'foobar' }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST send_token' do
    let(:terminal) { create(:terminal) }

    def go(id, email = 'foo@bar.com')
      post :send_token, params: { device_email: { email: email },
                                  id: id }
    end

    context 'when logged in' do

      before do
        sign_in user
      end

      context 'when terminal is found' do
        it 'renders show template' do
          go(terminal.id)
          expect(response).to render_template('show')
        end

        it 'assigns device_email and qr_pairing_token' do
          go(terminal.id)
          expect(assigns(:device_email)).to be_a(DeviceEmail)
          expect(assigns(:qr_pairing_token)).not_to be_nil
        end

        it 'sets flash message' do
          go(terminal.id)
          expect(flash[:success]).to eq("Enviado instrucciones a <strong>foo@bar.com</strong>.")
        end

        it 'sends email' do
          go(terminal.id)
          expect(last_email.to).to include('foo@bar.com')
        end
      end

      context 'when terminal is not found' do
        it 'redirects to not found' do
          go('foobar')
          expect(response).to have_http_status(:not_found)
        end

        it 'does not send email' do
          go('foobar')
          expect(last_email).to be_nil
        end
      end

      context 'when email is invalid' do
        it 'sets flash message' do
          go(terminal.id, '')
          expect(flash[:danger]).to match(/No se ha podido enviar el correo./)
          expect(response).to render_template('terminals/show')
        end

        it 'does not send email' do
          go(terminal.id, '')
          expect(last_email).to be_nil
        end

        it 'assigns device_email and qr_pairing_token' do
          go(terminal.id)
          expect(assigns(:device_email)).to be_a(DeviceEmail)
          expect(assigns(:qr_pairing_token)).not_to be_nil
        end
      end
    end

    context 'when logged out' do
      it 'redirects to sign in' do
        go(terminal.id)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE pair_device' do
    let(:terminal) { create(:terminal) }
    let(:device) { create(:device, terminal_id: terminal.id) }

    def go(id)
      delete :unpair_device, params: { id: id }
    end

    context 'when logged in' do
      before do
        sign_in user
      end

      context 'when device is found' do
        it 'redirects to terminal' do
          go(terminal.id)
          expect(response).to redirect_to(terminal_path(terminal))
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
        it 'redirects to not_found' do
          go('foobar')
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when logged out' do
      it 'redirects to sign in' do
        go(terminal.id)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
