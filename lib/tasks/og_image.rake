namespace :og do
  desc 'Generate default Open Graph image'
  task generate_default: :environment do
    require 'mini_magick'

    # Create a simple OG image
    image = MiniMagick::Image.open('canvas:1200x630:#f5f0e8')

    # Add text
    image.combine_options do |c|
      c.font 'Arial'
      c.pointsize 72
      c.fill '#6b0000'
      c.gravity 'center'
      c.annotate '+0-50', 'Zz Chan'
    end

    image.combine_options do |c|
      c.font 'Arial'
      c.pointsize 36
      c.fill '#2d1b00'
      c.gravity 'center'
      c.annotate '+0+50', '討論板平台'
    end

    # Save the image
    image.write('public/og-default.png')
    puts 'Default OG image generated: public/og-default.png'
  end
end
