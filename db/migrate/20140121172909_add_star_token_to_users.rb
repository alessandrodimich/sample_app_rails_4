class AddStarTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :star_token, :string
  end
end
