class AddIndexToCaptchas < ActiveRecord::Migration
  def change
    add_index :captchas, :visit_id
  end
end
