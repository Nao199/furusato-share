class Point < ApplicationRecord
  belongs_to :food_transaction, class_name: 'Transaction', foreign_key: 'transaction_id'
  belongs_to :user

  validates :point_type, presence: true, inclusion: { in: [1, -1] }
  validates :amount, presence: true, numericality: { greater_than: 0 }

end
