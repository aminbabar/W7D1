class User < ApplicationRecord
    validates :username, :password_digest, presence: true 
    validates :session_token, presence: true, uniqueness: true 
    #after initialize session token
    def reset_session_token! 
        self.session_token = User.generate_session_token
        self.save!
        self.session_token
    end

    def generate_session_token 
        SecureRandom.base64(16)
    end
end