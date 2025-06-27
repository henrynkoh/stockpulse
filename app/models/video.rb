class Video < ApplicationRecord
  belongs_to :stock
  
  validates :script, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending approved produced uploaded failed] }
  validates :youtube_id, uniqueness: true, allow_nil: true
  
  before_validation :set_initial_status, on: :create
  after_create :generate_video_assets
  
  private
  
  def set_initial_status
    self.status ||= 'pending'
  end
  
  def generate_video_assets
    return unless status == 'approved'
    VideoProductionJob.perform_later(id)
  end
end
