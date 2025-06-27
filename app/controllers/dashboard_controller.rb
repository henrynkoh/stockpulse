class DashboardController < ApplicationController
  def index
    @stocks = Stock.order(ticker: :asc)
    @videos = Video.includes(:stock).order(created_at: :desc).limit(20)
  end
  
  def approve_video
    video = Video.find(params[:id])
    video.update!(status: 'approved')
    VideoProductionJob.perform_later(video.id)
    redirect_to root_path, notice: 'Video approved for production'
  rescue StandardError => e
    redirect_to root_path, alert: "Failed to approve video: #{e.message}"
  end
  
  def generate_video
    stock = Stock.find(params[:id])
    video = ScriptGeneratorService.generate(stock)
    redirect_to root_path, notice: 'Video script generated'
  rescue StandardError => e
    redirect_to root_path, alert: "Failed to generate video: #{e.message}"
  end
  
  def crawl_stocks
    StockCrawlerJob.perform_later
    redirect_to root_path, notice: 'Stock crawling job queued'
  rescue StandardError => e
    redirect_to root_path, alert: "Failed to queue stock crawling: #{e.message}"
  end
end 