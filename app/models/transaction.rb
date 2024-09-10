class Transaction < ApplicationRecord
  belongs_to :food
  belongs_to :provider, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  has_many   :points

  enum status: { 保留中: 0, 完了: 1, キャンセル: 2 }

  validates :food, :provider, :receiver, :status, presence: true

end
