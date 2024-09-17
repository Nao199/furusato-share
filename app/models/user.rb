class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ユーザーは複数の食品を持つことができる
  has_many :foods
  # ユーザーは複数のポイントを持つことができる
  has_many :points
  # ユーザーが提供者となっている取引（トランザクション）
  has_many :provided_transactions, class_name: 'Transaction', foreign_key: 'provider_id'
  # ユーザーが受取人となっている取引（トランザクション）
  has_many :received_transactions, class_name: 'Transaction', foreign_key: 'receiver_id'

  # おすそわけポイントを更新するメソッド
  def update_osusowake_point
    # 総ポイント = 初期ポイント(3) + 共有回数 - 受取回数
    total_points = 3 + share_count - receive_count
    # おすそわけポイントを更新
    update(osusowake_point: total_points)
  end
end