require 'rails_helper'

describe TerminalsController do
  let(:user) { create(:user, tenant_id: @tenant.id) }

  describe 'GET index' do
    context 'when logged out' do
      it 'redirects to sign' do
        get :index, params: { organization: @tenant.organization }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when logged in' do
      it 'shows terminals list' do
        sign_in user
        get :index, params: { organization: @tenant.organization }
        expect(response).to be_success
        expect(response).to render_template('terminals/index')
      end
    end
  end

  describe 'GET new' do
    context 'when logged in' do
      it 'shows new terminal form' do
        sign_in user
        get :new, params: { organization: @tenant.organization }

        expect(response).to be_success
        expect(response).to render_template('terminals/new')
      end
    end

    context 'when logged out' do
      it 'redirects to sign in' do
        get :new, params: { organization: @tenant.organization }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST create' do
    context 'when logged in' do
      before do
        sign_in user
      end

      context 'when data is valid' do
        it 'creates a terminal' do
          expect do
            post :create, params: {
                            organization: @tenant.organization,
                            terminal: { name: 'foobar' }
                          }
          end.to change { Terminal.count }.by(1)

          expect(response).to redirect_to(terminals_path(@tenant.organization))
        end
      end

      context 'when data is invalid' do
        it 'shows error list' do
          expect do
            post :create, params: {
                            organization: @tenant.organization,
                            terminal: { name: '' }
                          }
          end.to change { Terminal.count }.by(0)

          expect(response).to render_template('terminals/new')
        end
      end
    end

    context 'when logged out' do
      it 'redirects to sign in' do
        post :create, params: {
                        organization: @tenant.organization,
                        terminal: { name: 'foobar' }
                      }

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
        let(:terminal) { create(:terminal) }

        it 'shows the terminal' do
          get :show, params: { organization: @tenant.organization,
                                id: terminal.id }

          expect(response).to be_success
          expect(response).to render_template('terminals/show')
        end
      end

      context 'when terminal is not found' do
        it 'redirects to terminals with flash' do
          get :show, params: { organization: @tenant.organization, id: 'foobar' }

          expect(response).to redirect_to(terminals_path(@tenant.organization))
          expect(flash[:primary]).to match(/La terminal no existe/)
        end
      end
    end

    context 'when logged out' do
      it 'redirects to sign in' do
        get :show, params: { organization: @tenant.organization, id: 'foobar' }

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
          get :edit, params: { organization: @tenant.organization, id: terminal.id }

          expect(response).to be_success
          expect(response).to render_template('terminals/edit')
        end
      end

      context 'when terminal is not found' do
        it 'redirects to terminals with flash' do
          get :edit, params: { organization: @tenant.organization, id: 'foobar' }

          expect(response).to redirect_to(terminals_path(@tenant.organization))
          expect(flash[:primary]).to match(/La terminal no existe/)
        end
      end
    end

    context 'when logged out' do
      it 'redirects to sign in' do
        get :edit, params: { organization: @tenant.organization, id: 'foobar' }
      end
    end
  end

  describe 'UPDATE' do
    context 'when logged in' do
      before do
        sign_in user
      end

      context 'when terminal is found' do
        let(:terminal) { create(:terminal) }


        it 'updates terminal' do
          patch :update, params: { organization: @tenant.organization,
                                    terminal: { name: 'foobar' },
                                    id: terminal.id }

          terminal.reload
          expect(terminal.name).to eq('foobar')
          expect(response).to redirect_to(terminal_path(terminal))
          expect(flash[:success]).to match(/Actualizado correctamente./)
        end
      end

      context 'when invalid data' do
        let(:terminal) { create(:terminal) }

        it 'shows errors with flash' do
          patch :update, params: { organization: @tenant.organization,
                                    terminal: { name: '' },
                                    id: terminal.id }

          expect(response).to render_template 'terminals/edit'
        end
      end

      context 'when terminal is not found' do
        it 'redirects to terminals with flash' do
          patch :update, params: { organization: @tenant.organization,
                                    id: 'foobar' }

          expect(response).to redirect_to(terminals_path)
          expect(flash[:primary]).to match(/La terminal no existe/)
        end
      end
    end

    context 'when logged out' do
      it 'redirects to sign in' do
        patch :update, params: { organization: @tenant.organization,
                                  id: 'foobar' }
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
        it 'redirects to terminals with flash' do
          terminal = create(:terminal)
          expect do
            delete :destroy, params: { organization: @tenant.organization,
                                      id: terminal.id }
          end.to change { Terminal.count }.by(-1)

          expect(response).to redirect_to(terminals_path(@tenant.organization))
          expect(flash[:success]).to match(/La terminal ha sido eliminada/)
        end
      end

      context 'when terminal is not found' do
        it 'redirects to terminals with flash' do
          expect do
            delete :destroy, params: { organization: @tenant.organization,
                                      id: 'foobar' }
          end.to change { Terminal.count }.by(0)

          expect(response).to redirect_to(terminals_path(@tenant.organization))
          expect(flash[:primary]).to match(/La terminal no existe/)
        end
      end
    end

    context 'when logged out' do
      it 'redirects to sign in' do
        delete :destroy, params: { organization: @tenant.organization,
                                  id: 'foobar' }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST send_token' do
    let(:terminal) { create(:terminal) }

    def go(id, email = 'foo@bar.com')
      post :send_token, params: { organization: @tenant.organization,
                                  device_email: { email: email },
                                  id: id }
    end

    context 'when logged in' do

      before do
        sign_in user
      end


      context 'when terminal is found' do
        it 'redirects to terminal with flash' do
          go(terminal.id)
          expect(response).to redirect_to(terminal_path(terminal))
        end

        it 'flashes success message' do
          go(terminal.id)
          expect(flash[:success]).to eq("Enviado instrucciones a <strong>foo@bar.com</strong>.")
        end

        it 'sends email' do
          go(terminal.id)
          expect(last_email.to).to include('foo@bar.com')
        end
      end

      context 'when terminal is not found' do
        it 'shows flash message' do
          go('foobar')

          expect(flash[:primary]).to match(/La terminal no existe/)
          expect(response).to redirect_to(terminals_path(@tenant.organization))
        end

        it 'does not send email' do
          go('foobar')

          expect(last_email).to be_nil
        end
      end

      context 'when email is invalid' do
        it 'shows flash message' do
          go(terminal.id, '')

          expect(flash[:danger]).to match(/No se ha podido enviar el correo./)
          expect(response).to render_template('terminals/show')
        end

        it 'does not send email' do
          go(terminal.id, '')

          expect(last_email).to be_nil
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
    let(:device) { create(:device, terminal_id: terminal.id, current: true) }

    def go(id)
      delete :unpair_device, params: { organization: @tenant.organization,
                                      id: id }
    end

    context 'when logged in' do
      before do
        sign_in user
      end

      context 'when device is found' do
        it 'redirects to terminal' do
          go(terminal.id)

          expect(response).to redirect_to(terminal_path(@tenant.organization, terminal))
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

          expect(response).to redirect_to(terminals_path(@tenant.organization))
          expect(flash[:primary]).to match(/La terminal no existe/)
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
