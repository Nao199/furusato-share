# app/services/point_calculator.rb
class PointCalculator
  def self.calculate_total(user)
    initial_points = 3
    shared_points = user.share_count
    received_points = user.points.where(point_type: -1).sum(:amount)
    initial_points + shared_points - received_points
  end

  def self.add_points(user, amount)
    user.points.create!(point_type: 1, amount: amount)
    user.update_osusowake_point
  end

  def self.use_points(user, amount)
    user.points.create!(point_type: -1, amount: amount)
    user.update_osusowake_point
  end
end