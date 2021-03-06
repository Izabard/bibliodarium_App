class Book < ApplicationRecord 
    def finished?
        !finished_at.blank?
    end
    enum status: { started: 0, reading: 1, finished: 2, cancelled: 3 } do
    
    event :start do
        after do
        self.started_at = DateTime.now
        self.save
        end
        transition :started => :reading
    end
    event :cancel do
        after do
         self.cancelled_at = DateTime.now
         self.save
        end
        transition :started => :cancelled
    end
    event :finish do
        after do
         self.finished_at = DateTime.now
         self.save
        end
        transition :reading => :finished
    end
    end
    belongs_to :user
    belongs_to :category
    default_scope -> { order(created_at: :desc) }
    mount_uploader :cover, CoverUploader
    validates :user_id, presence: true
    validates :title, presence: true
    validates :author, presence: true
    validates :category, presence: true
    validates :cover, presence: false
    validate :cover_size

    def time_reading(param1, param2 = Time.now)
        time_diff = (param2 - param1)
        return (time_diff / 1.day).round
    end     

    private
    def cover_size
        if cover.size > 1.megabytes
            errors.add(:cover, "should be less than 1 MB")
        end
    end
end
