class Food < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :user
  has_one_attached :image
  has_many :transactions
  belongs_to_active_hash  :category
  belongs_to_active_hash  :furusato
  belongs_to :pickup_location

  def self.search(keyword)
    if keyword.present?
      where('name LIKE ? OR description LIKE ?', "%#{keyword}%", "%#{keyword}%")
    else
      all
    end
  end
  
  enum status: { 利用可能: 0, 予約済み: 1, 共有済み: 2 }

end
