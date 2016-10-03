class AddIndexToPages < ActiveRecord::Migration
  def change
    add_index :pages, :visit_id
  end
end
