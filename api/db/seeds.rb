# frozen_string_literal: true

include FactoryBot::Syntax::Methods

20.times do
  create(:user)
  create(:user, is_block: true)
end

create(:user, role: 'admin', email: 'admin@test.com', password: 'password')
