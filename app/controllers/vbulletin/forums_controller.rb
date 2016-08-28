require 'vbulletin_scraper'

class Vbulletin::ForumsController < ApplicationController
    public
        def index
            if params[:url].present?
                url = params[:url]

                forumScraper = VbulletinScraper::V4::ForumScraper.new(url)
                forum = Forum.new
                forum.is_vbulletin = forumScraper.is_valid_vbulletin
                forum.vbulletin_version = forumScraper.get_vbulletin_version
                forum.title = forumScraper.get_forum_title
                forum.url = forumScraper.get_forum_url

                render json: forum
            else
                render_missing_url_parameter_json
            end
        end
end