# Custom UUID attribute type for MySQL binary storage with base36 string representation
# refs: https://github.com/basecamp/fizzy/blob/49c4f2adc6069d8e58f3091a797e9182d85ebbb6/lib/rails_ext/active_record_uuid_type.rb
module ActiveRecord
  module Type
    class Uuid < Binary
      BASE36_LENGTH = 25 # 36^25 > 2^128

      def self.generate
        uuid = SecureRandom.uuid_v7
        hex = uuid.delete("-")
        normalize_base36(hex.to_i(16))
      end

      def self.normalize_base36(integer)
        integer.to_s(36).rjust(BASE36_LENGTH, "0")
      end

      def serialize(value)
        return unless value

        binary = hex(value).scan(/../).map(&:hex).pack("C*")
        super(binary)
      end

      def hex(value)
        value.to_s.to_i(36).to_s(16).rjust(32, "0")
      end

      def deserialize(value)
        return unless value

        hex = value.to_s.unpack1("H*")
        Uuid.normalize_base36(hex.to_i(16))
      end

      def cast(value)
        value
      end
    end
  end
end

# Register the UUID type for Trilogy (MySQL), SQLite3, and PostgreSQL adapters
ActiveRecord::Type.register(:uuid, ActiveRecord::Type::Uuid, adapter: :trilogy)
ActiveRecord::Type.register(:uuid, ActiveRecord::Type::Uuid, adapter: :sqlite3)
ActiveRecord::Type.register(:uuid, ActiveRecord::Type::Uuid, adapter: :postgresql)
