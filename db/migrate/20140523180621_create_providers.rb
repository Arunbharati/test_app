class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :uuid
      t.string :provider_name
      t.references :user

      t.timestamps
    end
  end
end
