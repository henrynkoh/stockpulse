# StockPulse - Automated Stock Trading YouTube Shorts

StockPulse is an automated system that generates and publishes daily YouTube Shorts analyzing NYSE and Nasdaq stocks. The system focuses on momentum analysis, buy/sell pressure, short volume, and news sentiment to provide actionable trading insights.

## Features

- **Automated Stock Analysis**
  - Real-time stock data from Alpha Vantage API
  - RSI (Relative Strength Index) calculation
  - Short interest monitoring
  - News sentiment analysis
  - Buy/Sell/Hold signals

- **Automated Video Production**
  - 45-second YouTube Shorts
  - Professional text-to-speech narration
  - Dynamic stock charts and visuals
  - Automated thumbnail generation
  - YouTube upload with metadata

- **Dashboard Interface**
  - Stock monitoring and management
  - Video approval workflow
  - YouTube upload status tracking
  - Manual video generation triggers

## Requirements

- Ruby 3.2.2
- Rails 7.1
- SQLite3
- Redis (for Sidekiq)
- Python 3.x (for MoviePy)
- Google Cloud Console account
- API keys (Alpha Vantage, NewsAPI)

## Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/stockpulse.git
   cd stockpulse
   ```

2. Install Ruby dependencies:
   ```bash
   bundle install
   ```

3. Install Python dependencies:
   ```bash
   pip install moviepy gTTS requests
   ```

4. Set up environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your API keys
   ```

5. Set up the database:
   ```bash
   rails db:create db:migrate
   ```

6. Start the Rails server:
   ```bash
   rails server
   ```

7. Start Sidekiq:
   ```bash
   bundle exec sidekiq
   ```

## Configuration

### API Keys

1. **Alpha Vantage API**
   - Sign up at https://www.alphavantage.co/
   - Get your API key
   - Add to `.env`: `ALPHA_VANTAGE_API_KEY=your_key`

2. **NewsAPI**
   - Sign up at https://newsapi.org/
   - Get your API key
   - Add to `.env`: `NEWSAPI_KEY=your_key`

3. **Google/YouTube API**
   - Create a project in Google Cloud Console
   - Enable YouTube Data API v3
   - Create a service account
   - Download JSON credentials
   - Add to `.env`: `GOOGLE_CREDENTIALS=your_json_credentials`

### Scheduling

Stock data crawling and video generation are scheduled using Sidekiq:
- Runs Monday through Friday at 6 AM EST
- Configure in `config/sidekiq.yml`

## Usage

1. Access the dashboard at `http://localhost:3000`
2. Monitor stocks and video production
3. Approve pending videos
4. Trigger manual video generation
5. Monitor YouTube uploads

## Development

### Running Tests

```bash
bundle exec rspec
```

### Code Style

```bash
bundle exec rubocop
```

## Production Deployment

1. Set up a production server
2. Configure environment variables
3. Set up SSL certificate
4. Configure Redis
5. Set up Sidekiq as a service
6. Configure YouTube API for production

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Alpha Vantage for stock data
- NewsAPI for news sentiment
- Google Cloud/YouTube API for video publishing
- MoviePy for video generation
- gTTS for text-to-speech conversion
