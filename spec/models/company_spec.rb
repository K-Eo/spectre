require 'rails_helper'

RSpec.describe Company, type: :model do
  let(:company) { build(:company) }

  describe 'name' do
    context 'when is present' do
      it 'is valid' do
        expect(company).to be_valid
      end
    end

    context 'when is not present' do
      it 'is not valid' do
        company.name = ''
        expect(company).not_to be_valid
      end
    end

   context 'when length is eq or less than 255' do
     it 'is valid' do
       company.name = 'a' * 255
       expect(company).to be_valid
     end
   end

    context 'when length is grater than 255' do
      it 'is invalid' do
        company.name = 'a' * 256
        expect(company).not_to be_valid
      end
    end
  end
end
