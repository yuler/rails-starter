# Custom UUID attribute type for MySQL binary storage with base36 string representation
# refs: https://github.com/basecamp/fizzy/blob/49c4f2adc6069d8e58f3091a797e9182d85ebbb6/lib/rails_ext/active_record_uuid_type.rb
module ActiveRecord
  module Type
    # UUID type for MySQL and SQLite (stored as binary/blob)
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

    # UUID type for PostgreSQL (stored natively as UUID, not binary)
    class PgUuid < String
      BASE36_LENGTH = 25 # 36^25 > 2^128

      def self.generate
        p "--------------------------------"
        p "PgUuid.generate"
        p "--------------------------------"
        uuid = SecureRandom.uuid_v7
        hex = uuid.delete("-")
        p "hex: #{hex}"
        p "normalize_base36: #{normalize_base36(hex.to_i(16))}"
        p "--------------------------------"
        normalize_base36(hex.to_i(16))
      end

      def self.normalize_base36(integer)
        integer.to_s(36).rjust(BASE36_LENGTH, "0")
      end

      def serialize(value)
        return unless value

        # Convert base36 string to standard UUID format for PostgreSQL
        hex = value.to_s.to_i(36).to_s(16).rjust(32, "0")
        format_uuid(hex)
      end

      def format_uuid(hex)
        "#{hex[0..7]}-#{hex[8..11]}-#{hex[12..15]}-#{hex[16..19]}-#{hex[20..31]}"
      end

      def deserialize(value)
        return unless value

        # PostgreSQL returns UUID as string, convert to base36
        hex = value.to_s.delete("-")
        PgUuid.normalize_base36(hex.to_i(16))
      end

      def cast(value)
        p "cast #{value}"
        return nil if value.nil?
        return value if value.is_a?(String) && value.length == BASE36_LENGTH && value.match?(/\A[0-9a-z]+\z/)

        # If it's a UUID format (with dashes), convert to base36
        if value.to_s.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
          hex = value.to_s.delete("-")
          PgUuid.normalize_base36(hex.to_i(16))
        else
          # Assume it's already base36 or try to convert
          value.to_s
        end
      end
    end
  end
end

# Register the UUID type for Trilogy (MySQL) and SQLite3 adapters (binary storage)
ActiveRecord::Type.register(:uuid, ActiveRecord::Type::Uuid, adapter: :trilogy)
ActiveRecord::Type.register(:uuid, ActiveRecord::Type::Uuid, adapter: :sqlite3)
# Register PostgreSQL-specific UUID type (native UUID storage)
p "--------------------------------"
p "Registering PgUuid type for PostgreSQL"
p "--------------------------------"
ActiveRecord::Type.register(:uuid, ActiveRecord::Type::PgUuid, adapter: :postgresql)
p "Registration complete"
p "--------------------------------"
