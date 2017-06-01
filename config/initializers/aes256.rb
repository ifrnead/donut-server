require 'aes'

module Devise
  module Encryptable
    module Encryptors
      class Aes256 < Base
        class << self

          def digest(password, stretches, salt, pepper)
            ::AES.encrypt(password, pepper, {:iv => salt})
          end
          alias :encrypt :digest

          def salt(stretches)
            ::AES.iv(:base_64)
          end

          def decrypt(encrypted_password, pepper)
            ::AES.decrypt(encrypted_password, pepper)
          end
        end
      end
    end
  end
end
