class Log < ActiveRecord::Base
  belongs_to :visit

  before_destroy :delete_log_file

  private

  def delete_log_file
    if !log_file_id.nil? and File.exist?(Rails.root.join('public', 'logs', log_file_id))
      File.delete(Rails.root.join('public', 'logs', log_file_id))
    end
  end
end
