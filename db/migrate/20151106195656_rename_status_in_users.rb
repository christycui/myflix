class RenameStatusInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :status, :active
  end
end
