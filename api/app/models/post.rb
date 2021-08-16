class Post < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { maximum: 50 }, uniqueness: true

  before_create do
    self.alias_name = I18n.transliterate(title).downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '') if title
  end

  before_update do
    if is_published_changed? 
      if is_published
        self.published_date = Time.zone.now 
      else
        self.published_date = ''
      end
    end
  end
end
