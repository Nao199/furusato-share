class CreateFoods < ActiveRecord::Migration[7.0]
  def change
    create_table :foods do |t|
      t.string     :name, null: false
      t.text       :description
      t.integer    :quantity, null: false
      t.date       :expiration_date, null: false
      t.text       :allergen_info
      t.integer    :category_id, null: false
      t.integer    :furusato_id, null: false
      t.integer    :status, null: false, default: 0
      t.datetime   :available_from, null: false
      t.datetime   :available_until, null: false
      t.integer    :pickup_location_id, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
