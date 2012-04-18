class CreateEmailMessages < ActiveRecord::Migration
  def change
    create_table :email_messages do |t|
      t.string :message_id
      t.datetime :response_timestap
      t.integer :project_id
      t.integer :person_id

      t.timestamps
    end
  end
end
