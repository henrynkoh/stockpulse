class VideoProductionJob < ApplicationJob
  queue_as :default
  
  def perform(video_id)
    video = Video.find(video_id)
    stock = video.stock
    
    # Generate video assets
    begin
      # Generate TTS audio
      system("gtts-cli '#{video.script}' --lang en --output tmp/#{video_id}_audio.mp3")
      
      # Create video with MoviePy
      create_video_script = <<~PYTHON
        from moviepy.editor import VideoFileClip, TextClip, CompositeVideoClip, AudioFileClip, ColorClip
        import numpy as np
        
        # Create background
        background = ColorClip(size=(1080, 1920), color=(0, 0, 0)).set_duration(45)
        
        # Add stock info text
        text = TextClip(
            "#{stock.ticker}\\n#{stock.sector}\\n\\nRSI: #{stock.rsi}\\nShort %: #{stock.short_percent}\\nSignal: #{stock.signal.upcase}",
            fontsize=70,
            color='white',
            size=(1080, 1920)
        ).set_duration(45)
        
        # Add disclaimer
        disclaimer = TextClip(
            "*For informational purposes only\\nConsult a financial advisor",
            fontsize=40,
            color='white',
            size=(1080, 400)
        ).set_duration(45).set_position(('center', 1600))
        
        # Load audio
        audio = AudioFileClip("tmp/#{video_id}_audio.mp3")
        
        # Create final video
        final = CompositeVideoClip([background, text.set_position('center'), disclaimer])
        final = final.set_audio(audio)
        
        # Write video file
        final.write_videofile(
            "public/videos/#{video_id}_final.mp4",
            fps=24,
            codec='libx264',
            audio_codec='aac'
        )
        
        # Generate thumbnail
        thumbnail = ColorClip(size=(1280, 720), color=(0, 0, 0))
        thumb_text = TextClip(
            "#{stock.ticker}\\n#{stock.signal.upcase}",
            fontsize=120,
            color='white',
            size=(1280, 720)
        ).set_duration(1)
        thumb_final = CompositeVideoClip([thumbnail, thumb_text.set_position('center')])
        thumb_final.save_frame("public/thumbnails/#{video_id}_thumb.jpg", t=0)
      PYTHON
      
      File.write("tmp/#{video_id}_generate_video.py", create_video_script)
      system("python tmp/#{video_id}_generate_video.py")
      
      # Update video paths
      video.update!(
        video_path: "public/videos/#{video_id}_final.mp4",
        thumbnail_path: "public/thumbnails/#{video_id}_thumb.jpg",
        status: 'produced'
      )
      
      # Clean up temporary files
      File.delete("tmp/#{video_id}_audio.mp3")
      File.delete("tmp/#{video_id}_generate_video.py")
      
      # Queue upload job
      YoutubeUploadJob.perform_later(video_id)
    rescue StandardError => e
      video.update!(status: 'failed')
      Rails.logger.error("Video production failed for video #{video_id}: #{e.message}")
    end
  end
end 