class AboutController < ApplicationController
  before_filter { use_cover_photo 'about.jpg' }

  def index
  end
end
