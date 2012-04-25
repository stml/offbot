class AddWeeklyDigestDayAndLastWeeklyDigestSentAtToProject < ActiveRecord::Migration
  def change
    add_column :projects, :weekly_digest_day, :string
    add_column :projects, :weekly_digest_sent_at, :datetime
  end
end
