class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.date :dob
      t.string :email, index: { unique: true }
      t.string :password
      t.string :password_digest
      t.string :profile_picture
      t.timestamps
    end
  end
end
