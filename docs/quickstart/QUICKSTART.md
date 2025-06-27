# StockPulse Quickstart Guide

Get up and running with StockPulse in under 10 minutes! This guide will help you set up your automated stock analysis and video production system quickly.

## Prerequisites

### System Requirements
- Ruby 3.2.2 or higher
- Python 3.x (3.8+ recommended)
- Redis 6.0+
- Node.js 14+ (for asset compilation)
- FFmpeg (for video processing)
- 4GB RAM minimum
- 20GB free disk space

### API Keys (we'll help you get these)
- Alpha Vantage API (Stock data)
- NewsAPI (Market news)
- YouTube Data API v3
- Google Cloud credentials

### Development Tools
- Git
- Text editor (VS Code recommended)
- Terminal access
- Web browser

## 15-Minute Setup

### 1. Environment Setup (5 minutes)
```bash
# Install system dependencies (macOS)
brew install ruby python redis ffmpeg

# Install system dependencies (Ubuntu)
sudo apt-get update
sudo apt-get install ruby python3 redis-server ffmpeg

# Verify installations
ruby -v
python3 --version
redis-cli ping
ffmpeg -version
```

### 2. Project Installation (3 minutes)
```bash
# Clone & Install
git clone https://github.com/yourusername/stockpulse.git
cd stockpulse
bundle install
pip install moviepy gTTS requests pandas numpy

# Initialize project
rails db:setup
yarn install
```

### 3. Configuration (4 minutes)
```bash
# Basic setup
cp .env.example .env
rails credentials:edit

# Generate secret key
rails secret

# Configure database
rails db:migrate
rails db:seed  # Load sample data
```

### 4. API Setup (3 minutes)
#### Alpha Vantage API
1. Visit https://www.alphavantage.co/support/#api-key
2. Register for free API key
3. Add to `.env`: `ALPHA_VANTAGE_API_KEY=your_key`

#### NewsAPI
1. Visit https://newsapi.org/register
2. Create account and verify email
3. Add to `.env`: `NEWSAPI_KEY=your_key`

#### YouTube API
1. Visit Google Cloud Console
2. Create new project
3. Enable YouTube Data API v3
4. Create credentials
5. Add to `.env`: `GOOGLE_CREDENTIALS=your_json`

### 5. Start Services (2 minutes)
```bash
# Terminal 1: Start Rails server
rails server

# Terminal 2: Start Sidekiq
bundle exec sidekiq

# Terminal 3: Start Redis (if not running)
redis-server
```

## Quick Verification

### 1. System Check
Visit http://localhost:3000
- Dashboard should load
- No error messages
- Stock data visible

### 2. Test Features
1. Click "Crawl Stocks"
2. Watch for job processing
3. Check video generation
4. Monitor uploads

### 3. Common Issues
- Port conflicts: Change in config/puma.rb
- Memory limits: Adjust in config/sidekiq.yml
- API rate limits: Check in .env

## Next Steps

### 1. Essential Customization
- Set preferred stocks
- Customize video templates
- Configure upload schedule
- Set up monitoring

### 2. Advanced Features
- Custom indicators
- Alert settings
- Backup configuration
- Performance tuning

### 3. Learning Resources
1. Watch the [video tutorial](link-to-video)
2. Read the [full documentation](link-to-docs)
3. Join our [Discord community](link-to-discord)
4. Follow our [YouTube channel](link-to-youtube)

### 4. Best Practices
- Regular backups
- API key rotation
- Performance monitoring
- Error tracking

## Quick Tips

### Performance Optimization
- Use background jobs
- Enable caching
- Optimize database queries
- Monitor memory usage

### Security Best Practices
- Secure API keys
- Enable 2FA
- Regular updates
- Access logging

### Content Strategy
- Consistent scheduling
- Trend monitoring
- Audience engagement
- Analytics tracking

## Support & Community

### Immediate Help
- Email: support@stockpulse.com
- Discord: [StockPulse Community](link-to-discord)
- GitHub Issues: [Report a bug](link-to-issues)
- Stack Overflow: Tag 'stockpulse'

### Community Resources
- Weekly webinars
- User forums
- Code examples
- Feature requests

### Documentation
- API reference
- Integration guides
- Troubleshooting
- Best practices

## Maintenance

### Daily Tasks
- Monitor jobs
- Check logs
- Verify uploads
- Update data

### Weekly Tasks
- Backup data
- Check analytics
- Update content
- Community engagement

### Monthly Tasks
- API key rotation
- Performance review
- Feature updates
- Security audit

## Success Metrics

### Key Indicators
- Upload success rate
- API response times
- User engagement
- Channel growth

### Monitoring Tools
- Built-in dashboard
- Log analysis
- Performance metrics
- YouTube analytics

### Growth Tracking
- Subscriber count
- View statistics
- Engagement rates
- Revenue metrics 