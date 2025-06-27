class StockCrawlerJob < ApplicationJob
  queue_as :default
  
  def perform
    Rails.logger.info "Starting stock crawling job at #{Time.current}"
    
    # Crawl stock data
    StockCrawlerService.crawl
    
    # Generate videos for stocks with significant changes
    Stock.find_each do |stock|
      next unless should_generate_video?(stock)
      
      begin
        ScriptGeneratorService.generate(stock)
      rescue StandardError => e
        Rails.logger.error("Failed to generate video for #{stock.ticker}: #{e.message}")
      end
    end
    
    Rails.logger.info "Completed stock crawling job at #{Time.current}"
  end
  
  private
  
  def should_generate_video?(stock)
    return true if stock.videos.empty?
    
    last_video = stock.videos.order(created_at: :desc).first
    return false if last_video.created_at > 24.hours.ago
    
    # Generate new video if:
    # 1. Signal changed
    # 2. RSI moved into overbought/oversold territory
    # 3. Short interest changed significantly
    # 4. Sentiment changed
    signal_changed = last_video.stock.signal != stock.signal
    rsi_extreme = (stock.rsi > 70 || stock.rsi < 30) && (last_video.stock.rsi < 70 && last_video.stock.rsi > 30)
    short_change = (stock.short_percent - last_video.stock.short_percent).abs > 5
    sentiment_changed = last_video.stock.sentiment != stock.sentiment
    
    signal_changed || rsi_extreme || short_change || sentiment_changed
  end
end 