class RemoveIdentificationFromPost < ActiveRecord::Migration[5.0]
  def change
    remove_column :posts, :identification, :string
  end
end
