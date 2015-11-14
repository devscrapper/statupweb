class CreateCustomStatistics < ActiveRecord::Migration
  def change
    create_table :custom_statistics do |t|
      t.references :policy, polymorphic: true, index: true
      t.belongs_to :statistic, index: true
      t.timestamps null: false
    end
  end
end
