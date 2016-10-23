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
                attachmentCounter = 1

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

                            if postComment.attachment
                                attachment = Facebook::Attachment.new
                                attachment.id = attachmentCounter
                                attachmentCounter += 1
                                attachment.description = postComment.attachment.description
                                if postComment.attachment.media
                                    attachment.image_height = postComment.attachment.media.image.height
                                    attachment.image_src = postComment.attachment.media.image.src
                                    attachment.image_width = postComment.attachment.media.image.width
                                end
                                if postComment.attachment.target
                                    attachment.target_id = postComment.attachment.target.id
                                    attachment.target_url = postComment.attachment.target.url
                                end
                                attachment.title = postComment.attachment.title
                                attachment.attachment_type = postComment.attachment.type
                                attachment.url = postComment.attachment.url

                                comment.attachment = attachment
                            end

                            if postComment.comments
                                postComment.comments.data.each do |postCommentComment|
                                    commentComment = Facebook::Comment.new
                                    commentComment.id = postCommentComment.id
                                    
                                    commentCommentUser = Facebook::User.new
                                    commentCommentUser.id = postCommentComment.from.id
                                    commentCommentUser.name = postCommentComment.from.name

                                    commentComment.from = commentCommentUser
                                    commentComment.message = postCommentComment.message

                                    if postCommentComment.attachment
                                        attachment = Facebook::Attachment.new
                                        attachment.id = attachmentCounter
                                        attachmentCounter += 1
                                        attachment.description = postCommentComment.attachment.description
                                        if postCommentComment.attachment.media
                                            attachment.image_height = postCommentComment.attachment.media.image.height
                                            attachment.image_src = postCommentComment.attachment.media.image.src
                                            attachment.image_width = postCommentComment.attachment.media.image.width
                                        end
                                        if postCommentComment.attachment.target
                                            attachment.target_id = postCommentComment.attachment.target.id
                                            attachment.target_url = postCommentComment.attachment.target.url
                                        end
                                        attachment.title = postCommentComment.attachment.title
                                        attachment.attachment_type = postCommentComment.attachment.type
                                        attachment.url = postCommentComment.attachment.url

                                        commentComment.attachment = attachment
                                    end

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

                    if postMash.attachments
                        postMash.attachments.data.each do |postAttachment|
                            attachment = Facebook::Attachment.new
                            attachment.id = attachmentCounter
                            attachmentCounter += 1
                            attachment.description = postAttachment.description
                            if postAttachment.media
                                attachment.image_height = postAttachment.media.image.height
                                attachment.image_src = postAttachment.media.image.src
                                attachment.image_width = postAttachment.media.image.width
                            end
                            if postAttachment.target
                                attachment.target_id = postAttachment.target.id
                                attachment.target_url = postAttachment.target.url
                            end
                            attachment.title = postAttachment.title
                            attachment.attachment_type = postAttachment.type
                            attachment.url = postAttachment.url

                            if postAttachment.subattachments
                                postAttachment.subattachments.data.each do |postSubAttachment|
                                    subAttachment = Facebook::Attachment.new
                                    subAttachment.id = attachmentCounter
                                    attachmentCounter += 1
                                    subAttachment.description = postSubAttachment.description
                                    if postSubAttachment.media
                                        subAttachment.image_height = postSubAttachment.media.image.height
                                        subAttachment.image_src = postSubAttachment.media.image.src
                                        subAttachment.image_width = postSubAttachment.media.image.width
                                    end
                                    if postSubAttachment.target
                                        subAttachment.target_id = postSubAttachment.target.id
                                        subAttachment.target_url = postSubAttachment.target.url
                                    end
                                    subAttachment.title = postSubAttachment.title
                                    subAttachment.attachment_type = postSubAttachment.type
                                    subAttachment.url = postSubAttachment.url

                                    attachment.subattachments << subAttachment
                                end
                            end

                            post.attachments << attachment
                        end
                    end

                    @feed.posts << post
                end
            else
                render_missing_url_parameter_json
            end
        end
end
