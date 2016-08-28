require 'vbulletin_scraper'

class Vbulletin::TopicsController < ApplicationController
    public
        def index
            if params[:url].present?
                url = params[:url]
                
                topicScraper = VbulletinScraper::V4::TopicScraper.new(url)
                topic = Topic.new
                topic.title = topicScraper.get_topic_title
                topic.url = topicScraper.get_topic_url

                render json: topic
            else
                render_missing_url_parameter_json
            end
        end
end