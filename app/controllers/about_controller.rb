class AboutController < ApplicationController
  before_filter { use_cover_photo 'about.png' }

  def index
  end
end
