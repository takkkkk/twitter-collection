class AddContentToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :content, :text
  end
end
