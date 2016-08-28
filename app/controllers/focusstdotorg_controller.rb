require 'vbulletin_scraper'

class FocusstdotorgController < ApplicationController
    public
        def index
            url = "http://www.focusst.org/forum/midwest-st-owners/6774-minnesota-st-owners.html"
            
            # Forum
            forumScraper = VbulletinScraper::V4::ForumScraper.new(url)
            forum = Forum.new()
            forum.is_vbulletin = forumScraper.is_valid_vbulletin
            forum.vbulletin_version = forumScraper.get_vbulletin_version
            forum.title = forumScraper.get_forum_title
            forum.url = forumScraper.get_forum_url

            # Topic
            topicScraper = VbulletinScraper::V4::TopicScraper.new(url)
            topic = Topic.new()
            topic.title = topicScraper.get_topic_title
            topic.url = topicScraper.get_topic_url

            # Posts
            stop = false
            currPageNumber = 9999
            posts = []

            until stop do
                currPageUrl = url + '?page=' + currPageNumber.to_s
                currPageScraper = VbulletinScraper::V4::TopicScraper.new(currPageUrl)
                currPagePosts = currPageScraper.get_posts

                currPagePosts.each do |postContent|
                    postScraper = VbulletinScraper::V4::PostScraper.new(postContent.to_s)

                    post = Post.new()
                    post.vbulletin_post_id = postScraper.get_vbulletin_post_id
                    post.author = postScraper.get_post_author
                    post.content = postScraper.get_post_content
                    post.submit_date = postScraper.get_post_submit_datetime
                    
                    posts << post
                    if posts.length >= VbulletinScraper.configuration.post_count
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

            posts.sort! { |a,b| b.submit_date <=> a.submit_date }

            render json: forum
        end
end