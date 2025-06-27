class ScriptGeneratorService
  def self.generate(stock)
    new(stock).generate
  end
  
  def initialize(stock)
    @stock = stock
  end
  
  def generate
    script = <<~SCRIPT
      #{generate_intro}
      
      #{generate_analysis}
      
      #{generate_signal}
      
      #{generate_outro}
    SCRIPT
    
    # Create video record
    @stock.videos.create!(
      script: script.strip,
      status: 'pending'
    )
  end
  
  private
  
  def generate_intro
    "Today we're analyzing #{@stock.ticker}, a leading #{@stock.sector.downcase} company."
  end
  
  def generate_analysis
    analysis = []
    
    # RSI analysis
    if @stock.rsi.present?
      analysis << if @stock.rsi > 70
        "The RSI is at #{@stock.rsi.round}, indicating overbought conditions."
      elsif @stock.rsi < 30
        "The RSI is at #{@stock.rsi.round}, suggesting oversold conditions."
      else
        "The RSI is at #{@stock.rsi.round}, showing neutral momentum."
      end
    end
    
    # Short interest analysis
    if @stock.short_percent.present? && @stock.short_percent > 0
      analysis << if @stock.short_percent > 15
        "High short interest at #{@stock.short_percent.round}% could signal bearish sentiment."
      elsif @stock.short_percent > 5
        "Moderate short interest at #{@stock.short_percent.round}% worth monitoring."
      else
        "Low short interest at #{@stock.short_percent.round}% suggests limited bearish pressure."
      end
    end
    
    # News sentiment
    if @stock.sentiment.present?
      analysis << case @stock.sentiment
      when 'positive'
        "Recent news coverage is positive, supporting bullish outlook."
      when 'negative'
        "Recent news coverage is negative, suggesting caution."
      else
        "News sentiment is neutral."
      end
    end
    
    analysis.join(' ')
  end
  
  def generate_signal
    case @stock.signal
    when 'buy'
      "Based on our analysis, #{@stock.ticker} shows a BUY signal at the current price of $#{@stock.price.round(2)}."
    when 'sell'
      "Our analysis indicates a SELL signal for #{@stock.ticker} at $#{@stock.price.round(2)}."
    else
      "We recommend a HOLD position on #{@stock.ticker} at $#{@stock.price.round(2)}."
    end
  end
  
  def generate_outro
    "Subscribe for daily stock trading insights! Remember, this is for informational purposes only. Always consult with a financial advisor before making investment decisions."
  end
end 