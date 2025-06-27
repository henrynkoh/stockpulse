require 'google/apis/youtube_v3'

class YoutubeUploadJob < ApplicationJob
  queue_as :default
  
  def perform(video_id)
    video = Video.find(video_id)
    return unless video.status == 'produced'
    
    begin
      youtube = Google::Apis::YoutubeV3::YouTubeService.new
      youtube.client_options.application_name = 'StockPulse'
      youtube.authorization = authorize_youtube
      
      # Prepare video metadata
      metadata = {
        snippet: {
          title: "#{video.stock.ticker}: #{video.stock.signal.upcase} Signal - Stock Analysis",
          description: generate_description(video),
          tags: generate_tags(video),
          category_id: '27' # Education category
        },
        status: {
          privacy_status: 'public',
          self_declared_made_for_kids: false
        }
      }
      
      # Upload video
      response = youtube.insert_video(
        'snippet,status',
        metadata,
        upload_source: video.video_path,
        content_type: 'video/mp4'
      )
      
      # Update video record with YouTube ID
      video.update!(youtube_id: response.id, status: 'uploaded')
      
      # Upload thumbnail
      youtube.set_thumbnail(
        response.id,
        upload_source: video.thumbnail_path,
        content_type: 'image/jpeg'
      )
    rescue StandardError => e
      video.update!(status: 'failed')
      Rails.logger.error("YouTube upload failed for video #{video_id}: #{e.message}")
    end
  end
  
  private
  
  def authorize_youtube
    # Use service account credentials from environment variable
    Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new(ENV['GOOGLE_CREDENTIALS']),
      scope: 'https://www.googleapis.com/auth/youtube.upload'
    )
  end
  
  def generate_description(video)
    stock = video.stock
    <<~DESCRIPTION
      #{stock.ticker} Stock Analysis
      
      Sector: #{stock.sector}
      RSI: #{stock.rsi}
      Short Interest: #{stock.short_percent}%
      Signal: #{stock.signal.upcase}
      
      Subscribe for daily stock trading insights!
      
      DISCLAIMER: This content is for informational purposes only.
      Always consult with a qualified financial advisor before making any investment decisions.
      
      #StockMarket #Trading #Investing ##{stock.ticker} #StockAnalysis
    DESCRIPTION
  end
  
  def generate_tags(video)
    stock = video.stock
    [
      'Stock Market',
      'Trading',
      'Investing',
      stock.ticker,
      'Stock Analysis',
      'Financial Education',
      'Stock Trading',
      stock.sector,
      'Market Analysis',
      'Investment Strategy'
    ]
  end
end 