Ads.configure do |config|
  config.renderer = lambda { |options|
    tag(
        :img,
        src: "http://placehold.it/500x65/ffff00/000099&text=Adsense+Placeholder"
    )
  }
end
