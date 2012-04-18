class AddUnconfirmedEmailToPeople < ActiveRecord::Migration
  def change
    add_column :people, :unconfirmed_email, :string
  end
end
