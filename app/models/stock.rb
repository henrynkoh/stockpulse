class Stock < ApplicationRecord
  has_many :videos, dependent: :destroy
  
  validates :ticker, presence: true, uniqueness: true
  validates :sector, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :volume, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :rsi, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true
  validates :short_volume, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :short_percent, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true
  validates :sentiment, inclusion: { in: %w[positive neutral negative] }, allow_nil: true
  validates :signal, inclusion: { in: %w[buy hold sell] }, allow_nil: true
  
  before_save :analyze_stock
  
  private
  
  def analyze_stock
    return if rsi.present? && sentiment.present? && signal.present?
    
    # Calculate RSI if not present
    self.rsi = calculate_rsi if rsi.nil?
    
    # Analyze sentiment if not present
    self.sentiment = analyze_sentiment if sentiment.nil?
    
    # Determine signal if not present
    self.signal = determine_signal if signal.nil?
  end
  
  def calculate_rsi
    # Simplified RSI calculation for MVP
    # In real implementation, this would use historical price data
    rand(20.0..80.0).round(2)
  end
  
  def analyze_sentiment
    return 'neutral' if news_url.blank?
    
    # Simple sentiment analysis based on news URL content
    # In real implementation, this would use NLP or external API
    %w[positive neutral negative].sample
  end
  
  def determine_signal
    score = 0
    
    # RSI analysis
    if rsi.present?
      score += 1 if rsi < 30  # Oversold
      score -= 1 if rsi > 70  # Overbought
    end
    
    # Short interest analysis
    if short_percent.present?
      score -= 1 if short_percent > 15  # High short interest
    end
    
    # Sentiment analysis
    if sentiment.present?
      score += 1 if sentiment == 'positive'
      score -= 1 if sentiment == 'negative'
    end
    
    case score
    when -Float::INFINITY..-1 then 'sell'
    when 1..Float::INFINITY then 'buy'
    else 'hold'
    end
  end
end
