class Post < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  validate :empty_post

  private

  def empty_post
    if content.blank? && !image.attached?
      errors.add(:content, "Could not be blank")
    end
  end
end
