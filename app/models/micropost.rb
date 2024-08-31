class Micropost < ApplicationRecord
  belongs_to :parent_post,class_name: "Micropost",optional: true
  has_many :replies,class_name: "Micropost",foreign_key: "parent_post_id"
  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [500, 500]
  end
  #has_one_attached :image 
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true 
  validates :content,presence:true,length:{maximum: 140}
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes,
                                      message:   "should be less than 5MB" }
   # スコープを追加
   scope :most_liked, ->(parent_post_id) {
  left_joins(:likes)
    .where(parent_post_id: parent_post_id)
    .group(:id)
    .unscope(:order) 
    .order('COUNT(likes.id) DESC')
    .select('microposts.*, COUNT(likes.id) as like_count')
}
end
