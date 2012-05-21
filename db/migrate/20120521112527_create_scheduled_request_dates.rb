class CreateScheduledRequestDates < ActiveRecord::Migration
  def change
    create_table :scheduled_request_dates do |t|
      t.references :person
      t.references :project
      t.datetime :request_date

      t.timestamps
    end
    add_index :scheduled_request_dates, :person_id
    add_index :scheduled_request_dates, :project_id
  end
end
