# This migration comes from spree (originally 20140713142214)
class RenameReturnAuthorizationReason < ActiveRecord::Migration[7.2]
  def change
    rename_column :spree_return_authorizations, :reason, :memo
  end
end
