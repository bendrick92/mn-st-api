require 'koala'
require 'hashie'
require 'json'

class Facebook::FeedsController < ApplicationController
    public
        def index
            if (params[:access_token].present? && params[:group_id].present? && params[:fields].present?)
                accessToken = params[:access_token]
                groupId = params[:group_id]
                fields = params[:fields].split(',')

                @feed = Facebook::Feed.new
                @feed.id = groupId

                graphObj = Koala::Facebook::API.new(accessToken)
                postHashes = graphObj.get_connection(groupId, 'feed', { limit: 25, fields: fields })
                postHashes.each do |postHash|
                    postMash = Hashie::Mash.new(postHash)

                    post = Facebook::Post.new
                    post.id = postMash.id
                    post.name = postMash.name
                    post.created_time = postMash.created_time

                    user = Facebook::User.new
                    user.id = postMash.from.id
                    user.name = postMash.from.name
                    post.from = user

                    post.post_link = postMash.link
                    post.picture = postMash.picture
                    post.message = postMash.message
                    post.type = postMash.type

                    if postMash.comments
                        postMash.comments.data.each do |postComment|
                            comment = Facebook::Comment.new
                            comment.id = postComment.id
                            
                            user = Facebook::User.new
                            user.id = postComment.from.id
                            user.name = postComment.from.name

                            comment.from = user
                            comment.message = postComment.message

                            if postComment.comments
                                postComment.comments.data.each do |postCommentComment|
                                    commentComment = Facebook::Comment.new
                                    commentComment.id = postCommentComment.id
                                    
                                    commentCommentUser = Facebook::User.new
                                    commentCommentUser.id = postCommentComment.from.id
                                    commentCommentUser.name = postCommentComment.from.name

                                    commentComment.from = commentCommentUser
                                    commentComment.message = postCommentComment.message

                                    comment.comments << commentComment
                                end
                            end

                            post.comments << comment
                        end
                    end

                    if postMash.likes
                        postMash.likes.data.each do |postLike|                        
                            user = Facebook::User.new
                            user.id = postLike.id
                            user.name = postLike.name

                            post.likes << user
                        end
                    end

                    @feed.posts << post
                end
            else
                render_missing_url_parameter_json
            end
        end
end
