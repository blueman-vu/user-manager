# frozen_string_literal: true

20.times do
  create(:user)
  create(:user, is_block: true)
end

create(:user, role: 'admin', email: 'admin@test.com', password: 'password')
