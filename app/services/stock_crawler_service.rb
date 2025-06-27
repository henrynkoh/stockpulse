class StockCrawlerService
  def self.crawl
    new.crawl
  end
  
  def crawl
    fetch_stocks.each do |stock_data|
      stock = Stock.find_or_initialize_by(ticker: stock_data[:ticker])
      stock.assign_attributes(stock_data)
      stock.save!
    end
  rescue StandardError => e
    Rails.logger.error("Stock crawling failed: #{e.message}")
    []
  end
  
  private
  
  def fetch_stocks
    # For MVP, we'll focus on popular tech stocks
    tickers = %w[AAPL GOOGL MSFT NVDA TSLA AMD META AMZN]
    
    tickers.map do |ticker|
      fetch_stock_data(ticker)
    end.compact
  end
  
  def fetch_stock_data(ticker)
    # Alpha Vantage API call
    response = HTTParty.get(
      "https://www.alphavantage.co/query",
      query: {
        function: 'GLOBAL_QUOTE',
        symbol: ticker,
        apikey: ENV['ALPHA_VANTAGE_API_KEY']
      },
      timeout: 10
    )
    
    quote = response['Global Quote']
    return nil unless quote.present?
    
    # Fetch additional data
    company_data = fetch_company_data(ticker)
    news = fetch_news(ticker)
    
    {
      ticker: ticker,
      sector: company_data[:sector],
      price: quote['05. price'].to_f,
      volume: quote['06. volume'].to_i,
      short_volume: company_data[:short_volume],
      short_percent: company_data[:short_percent],
      news_url: news
    }
  rescue StandardError => e
    Rails.logger.error("Failed to fetch data for #{ticker}: #{e.message}")
    nil
  end
  
  def fetch_company_data(ticker)
    # Alpha Vantage Company Overview API call
    response = HTTParty.get(
      "https://www.alphavantage.co/query",
      query: {
        function: 'OVERVIEW',
        symbol: ticker,
        apikey: ENV['ALPHA_VANTAGE_API_KEY']
      },
      timeout: 10
    )
    
    {
      sector: response['Sector'],
      # For MVP, we'll use random values for short data
      # In production, this would come from a proper data source
      short_volume: rand(1000000..5000000),
      short_percent: rand(5.0..20.0).round(2)
    }
  rescue StandardError => e
    Rails.logger.error("Failed to fetch company data for #{ticker}: #{e.message}")
    { sector: 'Technology', short_volume: 0, short_percent: 0 }
  end
  
  def fetch_news(ticker)
    # NewsAPI call
    response = HTTParty.get(
      "https://newsapi.org/v2/everything",
      query: {
        q: ticker,
        sortBy: 'publishedAt',
        language: 'en',
        apiKey: ENV['NEWSAPI_KEY']
      },
      timeout: 10
    )
    
    response.dig('articles', 0, 'url')
  rescue StandardError => e
    Rails.logger.error("Failed to fetch news for #{ticker}: #{e.message}")
    nil
  end
end 