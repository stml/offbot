class AddEmailKeyToPerson < ActiveRecord::Migration
  def change
    add_column :people, :email_key, :string
  end
end
