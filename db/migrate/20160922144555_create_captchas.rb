class CreateCaptchas < ActiveRecord::Migration
  def change
    create_table :captchas do |t|
      t.string :visit_id, null: false
      t.string :image_file_id, null: true
      t.integer :index, null: false
      t.string :text, null: false, default: "unknown"
      t.timestamps null: false
    end
  end
end
