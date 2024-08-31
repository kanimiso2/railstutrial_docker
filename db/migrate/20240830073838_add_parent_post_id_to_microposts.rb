class AddParentPostIdToMicroposts < ActiveRecord::Migration[7.0]
  def change
    add_column :microposts, :parent_post_id, :integer
    add_index :microposts, :parent_post_id
  end
end
