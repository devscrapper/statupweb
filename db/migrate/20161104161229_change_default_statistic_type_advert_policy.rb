class ChangeDefaultStatisticTypeAdvertPolicy < ActiveRecord::Migration
  def change
    change_column_default :adverts, :statistic_type, "default"
  end
end
