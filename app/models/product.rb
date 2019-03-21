class Product < ApplicationRecord

  belongs_to :user, foreign_key: :seller_id
  belongs_to :category
  belongs_to :prefecture
  belongs_to :postage
  belongs_to :shipping_method
  has_many :likes, dependent: :destroy
  has_many :users, through: :likes
  has_one  :trade
  has_many :comments
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true

  validates :name, presence: true
  validates :detail, presence: true
  validates :detail,    length: { maximum: 1000 }
  validates :category_id, presence: true
  validates :condition, presence: true
  validates :postage_id, presence: true
  validates :shipping_method_id, presence: true
  validates :prefecture_id, presence: true
  validates :date, presence: true
  validates :price, presence: true

  enum condition: {
    unused: 1,
    near_to_unused: 2,
    no_dirt: 3,
    bit_dirt: 4,
    dirt: 5,
    bad: 6
  }

  enum date: {
    oneday_twoday: 1,
    twoday_threeday: 2,
    fourday_sevenday: 3
  }

# FIXME: リファクタリング時に操作確認。現在、呼び出してもエラーになる
  # def category_decision
  #   if self.depth == 2
  #     @parent_category = self.root.name
  #     @child_category = self.parent.name
  #     @grandchild_category = self.name
  #   elsif self.depth == 1
  #     @parent_category = self.root.name
  #     @child_category = self.name
  #     @grandchild_category = "none"
  #   end
  # end

end
