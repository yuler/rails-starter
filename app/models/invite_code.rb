class InviteCode < ApplicationRecord
  before_create :generate_code

  class << self
    def claim!(code)
      if invite_code = find_by(code: code&.downcase)
        invite_code.destroy!
        true
      end
    end

    def valid?(code)
      find_by(code: code&.downcase).present?
    end

    def generate!
      create!.code
    end
  end

  private
    def generate_code
      loop do
        self.code = Base32.generate
        break code unless self.class.exists?(code: code)
      end
    end
end
