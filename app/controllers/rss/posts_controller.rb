require 'koala'
require 'hashie'
require 'json'
require 'vbulletin_scraper'

class Rss::PostsController < ApplicationController
    public
        def index
            @posts = []
            postCounter = 1

            # MN STs Facebook Group Feed
            accessToken = '1333570303337296%7CssnHtq9p3DuFAxX23XRx7Dc1reQ'
            groupId = '604231966385537'
            fields = ['id','name','created_time','type','link','picture','full_picture','message','from','comments{id,from,message,comments{id,from,message}}','likes','permalink_url']

            graphObj = Koala::Facebook::API.new(accessToken)
            mnStPostHashes = graphObj.get_connection(groupId, 'feed', { limit: 10, fields: fields })
            mnStPostHashes.each do |mnStPostHash|
                mnStPostMash = Hashie::Mash.new(mnStPostHash)

                facebookPost = Facebook::Post.new
                facebookPost.id = mnStPostMash.id
                facebookPost.name = mnStPostMash.name
                facebookPost.created_time = mnStPostMash.created_time

                facebookUser = Facebook::User.new
                facebookUser.id = mnStPostMash.from.id
                facebookUser.name = mnStPostMash.from.name
                facebookPost.from = facebookUser

                facebookPost.post_link = mnStPostMash.link
                facebookPost.picture = mnStPostMash.picture
                facebookPost.full_picture = mnStPostMash.full_picture
                facebookPost.message = mnStPostMash.message
                facebookPost.type = mnStPostMash.type
                facebookPost.permalink_url = mnStPostMash.permalink_url

                if mnStPostMash.comments
                    mnStPostMash.comments.data.each do |mnStPostComment|
                        facebookComment = Facebook::Comment.new
                        facebookComment.id = mnStPostComment.id
                        
                        facebookUser = Facebook::User.new
                        facebookUser.id = mnStPostComment.from.id
                        facebookUser.name = mnStPostComment.from.name

                        facebookComment.from = facebookUser
                        facebookComment.message = mnStPostComment.message

                        if mnStPostComment.comments
                            mnStPostComment.comments.data.each do |mnStPostCommentComment|
                                commentComment = Facebook::Comment.new
                                commentComment.id = mnStPostCommentComment.id
                                
                                commentCommentUser = Facebook::User.new
                                commentCommentUser.id = mnStPostCommentComment.from.id
                                commentCommentUser.name = mnStPostCommentComment.from.name

                                commentComment.from = commentCommentUser
                                commentComment.message = mnStPostCommentComment.message

                                facebookComment.comments << commentComment
                            end
                        end

                        facebookPost.comments << facebookComment
                    end
                end

                if mnStPostMash.likes
                    mnStPostMash.likes.data.each do |mnStPostLike|                        
                        facebookUser = Facebook::User.new
                        facebookUser.id = mnStPostLike.id
                        facebookUser.name = mnStPostLike.name

                        facebookPost.likes << facebookUser
                    end
                end

                post = Poly::Post.new
                post.id = postCounter
                post.post_type = 'facebook'
                post.facebook_post = facebookPost
                
                @posts << post
                postCounter += 1
            end

            # Minnesota ST Owners vBulletin Thread
            url = 'http://www.focusst.org/forum/midwest-st-owners/6774-minnesota-st-owners.html'
            currPageNumber = 9999
            stop = false
            vbulletinTopicCounter = 1
            vbulletinForumCounter = 1
            vbulletinPostCounter = 1
            vbulletinQuoteCounter = 1

            mnStTopicScraper = VbulletinScraper::V4::TopicScraper.new(url)

            vbulletinTopic = Vbulletin::Topic.new
            vbulletinTopic.id = vbulletinTopicCounter
            vbulletinTopic.title = mnStTopicScraper.get_topic_title
            vbulletinTopic.url = mnStTopicScraper.get_topic_url

            mnStForumScraper = VbulletinScraper::V4::ForumScraper.new(url)

            vbulletinForum = Vbulletin::Forum.new
            vbulletinForum.id = vbulletinForumCounter
            vbulletinForum.is_vbulletin = mnStForumScraper.is_valid_vbulletin
            vbulletinForum.vbulletin_version = mnStForumScraper.get_vbulletin_version
            vbulletinForum.title = mnStForumScraper.get_forum_title
            vbulletinForum.url = mnStForumScraper.get_forum_url

            until stop do
                currPageUrl = url + '?page=' + currPageNumber.to_s
                currPageScraper = VbulletinScraper::V4::TopicScraper.new(currPageUrl)
                currPagePosts = currPageScraper.get_posts

                currPagePosts.each do |vbulletinPostContent|
                    vbulletinPostScraper = VbulletinScraper::V4::PostScraper.new(vbulletinPostContent.to_s)

                    vbulletinPost = Vbulletin::Post.new
                    vbulletinPost.id = vbulletinPostCounter
                    vbulletinPost.vbulletin_post_id = vbulletinPostScraper.get_vbulletin_post_id
                    vbulletinPost.author = vbulletinPostScraper.get_post_author
                    vbulletinPost.post_content = vbulletinPostScraper.get_post_content
                    vbulletinPost.submit_date = vbulletinPostScraper.get_post_submit_datetime
                    vbulletinPost.post_permalink = vbulletinPostScraper.get_post_permalink
                    vbulletinPost.forum = vbulletinForum
                    vbulletinPost.topic = vbulletinTopic
                    
                    vbulletinQuotes = vbulletinPostScraper.get_quotes

                    vbulletinQuotes.each do |vbulletinQuoteContent|
                        vbulletinQuoteScraper = VbulletinScraper::V4::QuoteScraper.new(vbulletinQuoteContent.to_s)

                        vbulletinQuote = Vbulletin::Quote.new
                        vbulletinQuote.id = vbulletinQuoteCounter
                        vbulletinQuote.author = vbulletinQuoteScraper.get_quote_author
                        vbulletinQuote.quote_content = vbulletinQuoteScraper.get_quote_content

                        vbulletinPost.quotes << vbulletinQuote

                        vbulletinQuoteCounter += 1
                    end

                    post = Poly::Post.new
                    post.id = postCounter
                    post.post_type = 'vbulletin'
                    post.vbulletin_post = vbulletinPost

                    @posts << post
                    postCounter += 1

                    vbulletinPostCounter += 1

                    if vbulletinPostCounter >= 10
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

            @posts.sort! { |a,b| b.get_submit_date <=> a.get_submit_date }
        end
end