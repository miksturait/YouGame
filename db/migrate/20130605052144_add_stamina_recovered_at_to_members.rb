class AddStaminaRecoveredAtToMembers < ActiveRecord::Migration
  def change
    add_column :tracker_members, :stamina_recovered_at, :datetime
  end
end
