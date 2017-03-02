class User < ApplicationRecord
  validates :first_name, length: {minimum: 3}
  validates :last_name, length: {minimum: 3}
  validates_format_of :email, :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\Z/i
  validates :email, uniqueness: true
  validates :first_name , uniqueness: {scope: :last_name}

end
