require 'vbulletin_scraper'

class Vbulletin::TopicsController < ApplicationController
    public
        def index
            if params[:url].present?
                url = params[:url]
                currPageNumber = 9999
                stop = false
                topicCounter = 1
                forumCounter = 1
                postCounter = 1
                quoteCounter = 1

                topicScraper = VbulletinScraper::V4::TopicScraper.new(url)

                @topic = Vbulletin::Topic.new
                @topic.id = topicCounter
                @topic.title = topicScraper.get_topic_title
                @topic.url = topicScraper.get_topic_url

                forumScraper = VbulletinScraper::V4::ForumScraper.new(url)

                forum = Vbulletin::Forum.new
                forum.id = forumCounter
                forum.is_vbulletin = forumScraper.is_valid_vbulletin
                forum.vbulletin_version = forumScraper.get_vbulletin_version
                forum.title = forumScraper.get_forum_title
                forum.url = forumScraper.get_forum_url
                @topic.forum = forum

                until stop do
                    currPageUrl = url + '?page=' + currPageNumber.to_s
                    currPageScraper = VbulletinScraper::V4::TopicScraper.new(currPageUrl)
                    currPagePosts = currPageScraper.get_posts

                    currPagePosts.each do |postContent|
                        postScraper = VbulletinScraper::V4::PostScraper.new(postContent.to_s)

                        post = Vbulletin::Post.new
                        post.id = postCounter
                        post.vbulletin_post_id = postScraper.get_vbulletin_post_id
                        post.author = postScraper.get_post_author
                        post.post_content = postScraper.get_post_content
                        post.submit_date = postScraper.get_post_submit_datetime
                        
                        quotes = postScraper.get_quotes

                        quotes.each do |quoteContent|
                            quoteScraper = VbulletinScraper::V4::QuoteScraper.new(quoteContent.to_s)

                            quote = Vbulletin::Quote.new
                            quote.id = quoteCounter
                            quote.author = quoteScraper.get_quote_author
                            quote.quote_content = quoteScraper.get_quote_content

                            post.quotes << quote

                            quoteCounter += 1
                        end

                        @topic.posts << post
                        
                        postCounter += 1

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