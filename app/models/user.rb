class User < ApplicationRecord
  include BCrypt
  mount_uploader :profile_picture, ProfilePictureUploader
  has_secure_password
  validates :first_name, :last_name, :dob, :profile_picture, :email, presence: true
  validates :email, uniqueness: true

  def original_password
    byebug
    @original_password ||= Password.new(password_digest)
  end
end
