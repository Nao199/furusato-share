class Transaction < ApplicationRecord
  belongs_to :provider, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :food
  has_one :point

  validates :provider, presence: true
  validates :receiver, presence: true
  validates :food, presence: true
  validates :status, presence: true
  validate :provider_and_receiver_are_different

  enum status: { pending: 'pending', completed: 'completed', cancelled: 'cancelled' }

  scope :completed, -> { where(status: :completed) }
  scope :pending, -> { where(status: :pending) }

  def complete!
    transaction do
      update!(status: :completed, completed_at: Time.current)
      food.update!(status: :shared)
      PointCalculator.add_points(provider, 1)
      PointCalculator.use_points(receiver, 1)
      provider.increment!(:share_count)
    end
  end

  def cancel!
    update!(status: :cancelled)
    food.update!(status: :available)
  end

  def can_complete?(user)
    pending? && (user == receiver)
  end

  private

  def provider_and_receiver_are_different
    errors.add(:base, "提供者と受取人は同じユーザーにはなれません") if provider == receiver
  end
end