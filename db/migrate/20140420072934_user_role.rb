class UserRole < ActiveRecord::Migration
  def change
    create_table :roles_users, :id => false do |t|
      t.references :role, :user
      t.timestamps
    end
  end
end
