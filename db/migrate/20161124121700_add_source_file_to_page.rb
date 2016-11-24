class AddSourceFileToPage < ActiveRecord::Migration
  def change
    add_column :pages, :source_file_id, :string,  null: true
  end
end
