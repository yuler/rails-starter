class User < ApplicationRecord
  include Role

  belongs_to :account
  belongs_to :identity, optional: true

  validates :name, presence: true

  def deactivate
    transaction do
      accesses.destroy_all
      update! active: false, identity: nil
      close_remote_connections
    end
  end
end
