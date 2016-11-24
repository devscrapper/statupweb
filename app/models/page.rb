class Page < ActiveRecord::Base

  belongs_to :visit

  before_destroy :delete_image_file
  before_destroy :delete_source_file

  def has_image_file?
    !image_file_id.nil? and
        File.exist?(File.join("public", "images", image_file_id))
  end

  def has_source_file?
    !image_source_id.nil? and
        File.exist?(File.join("public", "sources", image_source_id))
  end
  private


  def delete_image_file
    if !image_file_id.nil? and File.exist?(Rails.root.join('public', 'images', image_file_id))
      File.delete(Rails.root.join('public', 'images', image_file_id))
    end
  end
  def delete_source_file
    if !image_source_id.nil? and File.exist?(Rails.root.join('public', 'sources', source_file_id))
      File.delete(Rails.root.join('public', 'sources', image_source_id))
    end
  end
end
