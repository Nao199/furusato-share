class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :provider, null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.string     :status, null: false, default: 'pending'
      t.datetime   :completed_at
      t.references :food, null: false, foreign_key: true

      t.timestamps
    end
  end
end