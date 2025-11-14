class InviteCode < ApplicationRecord
  before_create :generate_code

  class << self
    def claim!(code)
      if invite_code = find_by(code: code&.downcase)
        invite_code.destroy!
        true
      end
    end

    def generate!
      create!.code
    end
  end

  private
    def generate_code
      loop do
        self.code = SecureRandom.hex(4)
        break code unless self.class.exists?(code: code)
      end
    end
end
