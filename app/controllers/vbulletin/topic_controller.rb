require 'vbulletin_scraper'

class Vbulletin::TopicController < ApplicationController
    public
        def index
            if params[:url].present?
                url = params[:url]
                
                topicScraper = VbulletinScraper::V4::TopicScraper.new(url)

                @topic = Vbulletin::Topic.new
                @topic.title = topicScraper.get_topic_title
                @topic.url = topicScraper.get_topic_url

                forumScraper = VbulletinScraper::V4::ForumScraper.new(url)

                forum = Vbulletin::Forum.new
                forum.is_vbulletin = forumScraper.is_valid_vbulletin
                forum.vbulletin_version = forumScraper.get_vbulletin_version
                forum.title = forumScraper.get_forum_title
                forum.url = forumScraper.get_forum_url
                @topic.forum = forum

                stop = false
                currPageNumber = 9999
                counter = 1

                until stop do
                    currPageUrl = url + '?page=' + currPageNumber.to_s
                    currPageScraper = VbulletinScraper::V4::TopicScraper.new(currPageUrl)
                    currPagePosts = currPageScraper.get_posts

                    currPagePosts.each do |postContent|
                        postScraper = VbulletinScraper::V4::PostScraper.new(postContent.to_s)

                        post = Vbulletin::Post.new
                        post.id = counter
                        post.vbulletin_post_id = postScraper.get_vbulletin_post_id
                        post.author = postScraper.get_post_author
                        post.content = postScraper.get_post_content
                        post.submit_date = postScraper.get_post_submit_datetime
                        
                        @topic.posts << post
                        
                        counter += 1

                        if @topic.posts.length >= 10
                            stop = true
                        end
                    end

                    currPageNumber = currPageScraper.get_current_page_number

                    if currPageNumber > 1
                        currPageNumber -= 1
                    else
                        stop = true
                    end
                end

                @topic.posts.sort! { |a,b| b.submit_date <=> a.submit_date }
            else
                render_missing_url_parameter_json
            end
        end
end