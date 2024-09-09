class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :foods
  has_many :points
  has_many :provided_transactions, class_name: 'Transaction', foreign_key: 'provider_id'
  has_many :received_transactions, class_name: 'Transaction', foreign_key: 'receiver_id'

  def update_osusowake_point
    total_points = 3 + share_count - receive_count
    update(osusowake_point: total_points)
  end
end
