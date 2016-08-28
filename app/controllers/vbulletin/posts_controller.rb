require 'vbulletin_scraper'

class Vbulletin::PostsController < ApplicationController
    public
        def index
            if params[:url].present?
                url = params[:url]
            
                stop = false
                currPageNumber = 9999
                posts = []
                counter = 1

                until stop do
                    currPageUrl = url + '?page=' + currPageNumber.to_s
                    currPageScraper = VbulletinScraper::V4::TopicScraper.new(currPageUrl)
                    currPagePosts = currPageScraper.get_posts

                    currPagePosts.each do |postContent|
                        postScraper = VbulletinScraper::V4::PostScraper.new(postContent.to_s)

                        post = Post.new
                        post.id = counter
                        post.vbulletin_post_id = postScraper.get_vbulletin_post_id
                        post.author = postScraper.get_post_author
                        post.content = postScraper.get_post_content
                        post.submit_date = postScraper.get_post_submit_datetime
                        
                        posts << post
                        
                        counter += 1

                        if posts.length >= 3
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

                render json: posts, each_serializer: PostSerializer
            else
                render_missing_url_parameter_json
            end
        end
end