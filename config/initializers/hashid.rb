Hashid::Rails.configure do |config|
  # The minimum length of generated hashids
  config.min_hash_length = 16

  # The alphabet to use for generating hashids
  config.alphabet = "abcdefghijklmnopqrstuvwxyz" \
                    "ABCDEFGHIJKLMNOPQRSTUVWXYZ" \
                    "1234567890"

  # Whether to override the `find` method
  config.override_find = true
end
