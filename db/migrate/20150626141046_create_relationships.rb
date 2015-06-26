class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :user_id, :follower_id
      t.timestamps
    end
  end
end
