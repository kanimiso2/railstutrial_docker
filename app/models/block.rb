class Block < ApplicationRecord
    belongs_to :blocker, class_name: 'User'
    belongs_to :blocked, class_name: 'User'

    validates :blocker_id, presence: true
    validates :blocked_id, presence: true
    validate :not_self_blocking

    private

    def not_self_blocking
        errors.add(:blocked_id, "can't be the same as blocker") if blocker_id == blocked_id
    end
    
end
