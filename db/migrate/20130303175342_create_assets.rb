class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :file
      t.integer :subject_id
      t.string :subject_type
      t.datetime :uploaded_at
      t.timestamps
    end
  end
end
