require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'requires a first name' do
      user = build :user, first_name: nil
      user.valid?
      expect(user.errors).to have_key(:first_name)
    end
    it 'requires a last name' do
      user = build :user, last_name: nil
      user.valid?
      expect(user.errors).to have_key(:last_name)
    end
    it 'email must be unique' do
      create :user, email: 'test@test.com'
      user = build :user, email: 'test@test.com'
      user.valid?
      expect(user.errors).to have_key(:email)
    end
  end
  describe 'methods' do
    it 'full_name returns first name plus last name and titleized' do
      user = build :user, first_name: 'ron', last_name: 'burgandy'
      result = user.full_name
      expect(result).to eq('Ron Burgandy')
    end

  end
end
