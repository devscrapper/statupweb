class CreateSeas < ActiveRecord::Migration
  def change
    create_table :seas do |t|
      t.string :label, null: false
      t.string :advertiser, null: false
      t.string :keywords, null: false
      t.string :label_advertising, null: false
      t.timestamps null: false
    end
  end
end
