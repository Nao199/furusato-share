class Point < ApplicationRecord
  # アソシエーション（関連付け）の定義
  # このポイントは特定のトランザクションに属している
  # 'Transaction'モデルとの関連付けだが、food_transactionという名前で参照する
  belongs_to :food_transaction, class_name: 'Transaction', foreign_key: 'transaction_id'
  
  # このポイントは特定のユーザーに属している
  belongs_to :user

  # バリデーション（データの検証ルール）の定義
  # point_typeの検証
  validates :point_type, presence: true, inclusion: { in: [1, -1] }
  # presence: true - point_typeは必須（空であってはならない）
  # inclusion: { in: [1, -1] } - point_typeは1か-1のみ許可

  # amountの検証
  validates :amount, presence: true, numericality: { greater_than: 0 }
  # presence: true - amountは必須
  # numericality: { greater_than: 0 } - amountは0より大きい数値でなければならない

end
