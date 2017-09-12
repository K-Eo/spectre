require 'rails_helper'

describe GeoForm, type: :model do
  subject { GeoForm.new(current_user).update(params) }

  let(:current_user) { create(:user) }
  let(:lat) { 17.2695858 }
  let(:lng) { -97.6803423 }
  let(:params) {
    ActionController::Parameters.new({
      geo: { lat: lat, lng: lng }
    })
  }

  describe '#update' do
    context 'when geo is valid' do
      it { is_expected.to be_truthy }

      it 'updates lat and lng' do
        user = GeoForm.new(current_user)
        expect(user.update(params)).to be_truthy
        expect(user.user.lat).to eq(lat)
        expect(user.user.lng).to eq(lng)
      end
    end
  end
end
