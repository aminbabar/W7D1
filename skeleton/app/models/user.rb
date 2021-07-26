class User < ApplicationRecord
    validates :username, :password_digest, presence: true 
    validates :session_token, presence: true, uniqueness: true 
    #after initialize session token
    after_initialize :ensure_session_token

    def reset_session_token! 
        self.session_token = User.generate_session_token
        self.save!
        self.session_token
    end

    def generate_session_token 
        SecureRandom.base64(16)
    end

    def ensure_session_token
        self.session_token ||= User.generate_session_token
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        password_object = BCrypt::Password.new(self.password_digest)
        password_object.is_password?(password)
    end


    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        if user && user.is_password?(password)
            user
        else
            nil
        end
    end

    
end