class CreatePoints < ActiveRecord::Migration[7.0]
  def change
    create_table :points do |t|
      t.references :transaction, null: false, foreign_key: true
      t.integer    :point_type, null: false
      t.references :user, null: false, foreign_key: true
      t.integer    :amount, null: false, default: 0

      t.timestamps
    end
  end
end
