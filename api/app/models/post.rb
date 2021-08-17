include ActiveSupport::Inflector

class Post < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { maximum: 50 }, uniqueness: true
  #validates :alias_name, uniqueness: true 

  before_create do
    self.alias_name = I18n.transliterate(title).downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '') if title
    self.published_date = Time.zone.now if is_published
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

  scope :lists, lambda { |role, search|
    condition = role == 'admin' ? {} : { is_published: true }
    search = search.downcase if search
    where(condition).where('unaccent(LOWER(title)) LIKE ?', "%#{search}%")
    .order(created_at: :asc)
  }
end
