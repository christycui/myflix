class AddTokenToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :invitation_token, :string
    Invitation.all.each do |invitation|
      invitation.invitation_token = SecureRandom.urlsafe_base64
      invitation.save
    end
  end
end
