class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :visit_id, null: false
      t.string :image_file_id, null: true
      t.integer :index, null: false
      t.timestamps null: false
    end
  end
end
