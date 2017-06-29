class AddCreatedTimeToPost < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :created_time, :timestamps
  end
end
