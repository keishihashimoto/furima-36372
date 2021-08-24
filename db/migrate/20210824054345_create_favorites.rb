class CreateFavorites < ActiveRecord::Migration[6.0]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, presence: true
      t.references :item, null: false, presence: true
      t.timestamps
    end
  end
end
