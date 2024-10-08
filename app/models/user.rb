class User < ApplicationRecord
    has_many :chat_rooms_users
    has_many :chat_rooms, through: :chat_rooms_users
    has_many :active_blocks,class_name:"Block",
                            foreign_key: "blocker_id",
                            dependent: :destroy
    has_many :passive_blocks,class_name: "Block",
                            foreign_key: "blocked_id",
                            dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many :liked_microposts, through: :likes, source: :micropost
    has_many :microposts ,dependent: :destroy 
    has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
    has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy

    has_many :blocking,through: :active_blocks,source: :blocked
    has_many :blockers,through: :passive_blocks,source: :blocker
    has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships, source: :follower
    attr_accessor :remember_token ,:activation_token,:reset_token
    before_save { email.downcase! }
    before_create :create_activation_digest
    validates :name,  presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: true
    has_secure_password
    validates :password,presence:true,length:{minimum:6},allow_nil: true

    #渡された文字列ハッシュ化
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
    
    def User.new_token
        SecureRandom.urlsafe_base64
    end

    def remember
        self.remember_token = User.new_token
        #バリデーションを素通りさせる
        update_attribute(:remember_digest,User.digest(remember_token))
        remember_digest
    end

    # 渡されたトークンがダイジェストと一致したらtrueを返す
    # def authenticated?(attribute, token)
    #     digest = send("#{attribute}_digest")
    #     return false if digest.nil?
    #     BCrypt::Password.new(digest).is_password?(token)
    # end
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end

    def forget
        update_attribute(:remember_digest,nil)
    end

    def session_token
        remember_digest || remember
    end

    # アカウントを有効にする
    # def activate
    #     update_attribute(:activated,    true)
    #     update_attribute(:activated_at, Time.zone.now)
    # end
    
    def activate
        update_columns(activated: true,activated_at: Time.zone.now)
    end

    # 有効化用のメールを送信する
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end

     # パスワード再設定の属性を設定する
    def create_reset_digest
        self.reset_token = User.new_token
        update_attribute(:reset_digest,  User.digest(reset_token))
        update_attribute(:reset_sent_at, Time.zone.now)
    end

    

    # パスワード再設定のメールを送信する
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end

    # def feed
    #     Micropost.where("user_id = ?", id)
    # end

    # ユーザーをフォローする
    def follow(other_user)
        following << other_user unless self == other_user
    end

    # ユーザーをフォロー解除する
    def unfollow(other_user)
        following.delete(other_user)
    end

    # 現在のユーザーが他のユーザーをフォローしていればtrueを返す
    def following?(other_user)
        following.include?(other_user)
    end

    # ユーザーのステータスフィードを返す
    def feed(blockers_user_ids = [])
        following_ids = "SELECT followed_id FROM relationships
                        WHERE  follower_id = :user_id"
        Micropost.where("user_id IN (#{following_ids})
                         OR user_id = :user_id", user_id: id)
                        .where.not(user_id: blockers_user_ids)
                        .includes(:user, image_attachment: :blob)
    end

    #いいね機能
    def like(micropost)
        likes.create(micropost_id: micropost.id)
    end

    def unlike(micropost)
        likes.find_by(micropost_id:micropost.id).destroy
    end

     # ユーザーをブロックする
    def block(other_user)
        blocking << other_user unless blocked?(other_user) || self == other_user
    end

    # ユーザーのブロックを解除する
    def unblock(other_user)
        blocking.delete(other_user)
    end

    # 現在のユーザーが他のユーザーをブロックしていればtrueを返す
    def blocked?(other_user)
        blocking.include?(other_user)
    end
    # 他のユーザーが現在のユーザーをブロックしていればtrueを返す
    def blocked_by?(other_user)
        blockers.include?(other_user)
    end
    

    private
        # 有効化トークンとダイジェストを作成および代入する
        def create_activation_digest
            self.activation_token  = User.new_token
            self.activation_digest = User.digest(activation_token)
        end
        
  end
  