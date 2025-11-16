class Payment < ApplicationRecord
    def generate_license_key
        groups = 4.times.map { SecureRandom.hex(2).upcase }  # AB12 format
        groups.join("-")
    end
end
