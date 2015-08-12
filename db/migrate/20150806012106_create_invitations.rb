class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :friend_name, :email
      t.text :message
      t.integer :user_id
    end
  end
end
