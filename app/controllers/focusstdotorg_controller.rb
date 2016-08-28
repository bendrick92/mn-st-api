require 'vbulletin_scraper'

class FocusstdotorgController < ApplicationController
    public
        def index
            scraper = VbulletinScraper::V4::Scraper.new("http://www.focusst.org/forum/midwest-st-owners/6774-minnesota-st-owners.html")

            render json: scraper.posts
        end
end