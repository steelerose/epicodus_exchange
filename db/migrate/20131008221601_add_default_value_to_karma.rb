class AddDefaultValueToKarma < ActiveRecord::Migration
  def change
    remove_column :users, :karma

    add_column :users, :karma, :integer, default: 0
  end
end
