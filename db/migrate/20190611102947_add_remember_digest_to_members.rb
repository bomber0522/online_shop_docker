class AddRememberDigestToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :remember_digest, :string
  end
end
