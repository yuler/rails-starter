class InviteCode < ApplicationRecord
  LENGTH = 6

  before_create :generate_code

  class << self
    def claim!(code)
      if invite_code = find_by(code: Base32.sanitize(code))
        invite_code.destroy!
        true
      end
    end

    def valid?(code)
      find_by(code: Base32.sanitize(code)).present?
    end

    def generate!
      create!.code
    end
  end

  private
    def generate_code
      loop do
        self.code = Base32.generate(LENGTH)
        break code unless self.class.exists?(code:)
      end
    end
end
