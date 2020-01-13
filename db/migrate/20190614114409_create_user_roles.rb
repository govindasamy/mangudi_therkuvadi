class CreateUserRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :user_roles do |t|
      t.integer :user_id, index: true
      t.integer :role_id, index: true
      t.timestamps
    end
  end
end
