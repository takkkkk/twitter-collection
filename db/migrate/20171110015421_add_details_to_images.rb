class AddDetailsToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :profile_image_url, :string
    add_column :images, :profile_image_data, :binary
    add_column :images, :post_time, :datetime
  end
end
