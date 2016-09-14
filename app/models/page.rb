class Page < ActiveRecord::Base

  belongs_to :visit

  before_destroy :delete_image_file

  private

  def delete_image_file
    if !image_file_id.nil? and File.exist?(Rails.root.join('public', 'images', image_file_id))
      File.delete(Rails.root.join('public', 'images', image_file_id))
    end
  end
end
