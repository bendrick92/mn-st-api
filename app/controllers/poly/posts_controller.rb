require 'koala'
require 'hashie'
require 'json'
require 'vbulletin_scraper'

class Poly::PostsController < ApplicationController
    public
        def index
            @posts = []
            postCounter = 1
            
            # MN STs Facebook Group Feed
            accessToken = 'EAAS84Ag2o1ABAMwMK18scyhJ4jkfQknY7x5YqdhtqL0aGZCnw7ryiFnixAnqxQIPcJDupHRmEtujBccj9HA6o2w8TmbZCcnZB4ZCHlRVmB8HndzwZByPYqdaffsY2ZAkghipsLbXRlv7UM6SIjPKZBUw99OxniqzSZCMpZCZARpvWB1wZDZD'
            groupId = 'mnsts'
            fields = ['id','name','created_time','type','link','picture','full_picture','message','from','comments{id,from,message,attachment,comments{id,from,message,attachment}}','likes','permalink_url','attachments']
            attachmentCounter = 1

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

                        if mnStPostComment.attachment
                            attachment = Facebook::Attachment.new
                            attachment.id = attachmentCounter
                            attachmentCounter += 1
                            attachment.description = mnStPostComment.attachment.description
                            if mnStPostComment.attachment.media
                                attachment.image_height = mnStPostComment.attachment.media.image.height
                                attachment.image_src = mnStPostComment.attachment.media.image.src
                                attachment.image_width = mnStPostComment.attachment.media.image.width
                            end
                            if mnStPostComment.attachment.target
                                attachment.target_id = mnStPostComment.attachment.target.id
                                attachment.target_url = mnStPostComment.attachment.target.url
                            end
                            attachment.title = mnStPostComment.attachment.title
                            attachment.attachment_type = mnStPostComment.attachment.type
                            attachment.url = mnStPostComment.attachment.url

                            facebookComment.attachment = attachment
                        end

                        if mnStPostComment.comments
                            mnStPostComment.comments.data.each do |mnStPostCommentComment|
                                commentComment = Facebook::Comment.new
                                commentComment.id = mnStPostCommentComment.id
                                
                                commentCommentUser = Facebook::User.new
                                commentCommentUser.id = mnStPostCommentComment.from.id
                                commentCommentUser.name = mnStPostCommentComment.from.name

                                commentComment.from = commentCommentUser
                                commentComment.message = mnStPostCommentComment.message

                                if mnStPostCommentComment.attachment
                                    attachment = Facebook::Attachment.new
                                    attachment.id = attachmentCounter
                                    attachmentCounter += 1
                                    attachment.description = mnStPostCommentComment.attachment.description
                                    if mnStPostCommentComment.attachment.media
                                        attachment.image_height = mnStPostCommentComment.attachment.media.image.height
                                        attachment.image_src = mnStPostCommentComment.attachment.media.image.src
                                        attachment.image_width = mnStPostCommentComment.attachment.media.image.width
                                    end
                                    if mnStPostCommentComment.attachment.target
                                        attachment.target_id = mnStPostCommentComment.attachment.target.id
                                        attachment.target_url = mnStPostCommentComment.attachment.target.url
                                    end
                                    attachment.title = mnStPostCommentComment.attachment.title
                                    attachment.attachment_type = mnStPostCommentComment.attachment.type
                                    attachment.url = mnStPostCommentComment.attachment.url

                                    commentComment.attachment = attachment
                                end

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

                if mnStPostMash.attachments
                    mnStPostMash.attachments.data.each do |mnStPostAttachment|
                        attachment = Facebook::Attachment.new
                        attachment.id = attachmentCounter
                        attachmentCounter += 1
                        attachment.description = mnStPostAttachment.description
                        if mnStPostAttachment.media
                            attachment.image_height = mnStPostAttachment.media.image.height
                            attachment.image_src = mnStPostAttachment.media.image.src
                            attachment.image_width = mnStPostAttachment.media.image.width
                        end
                        if mnStPostAttachment.target
                            attachment.target_id = mnStPostAttachment.target.id
                            attachment.target_url = mnStPostAttachment.target.url
                        end
                        attachment.title = mnStPostAttachment.title
                        attachment.attachment_type = mnStPostAttachment.type
                        attachment.url = mnStPostAttachment.url

                        if mnStPostAttachment.subattachments
                            mnStPostAttachment.subattachments.data.each do |mnStPostSubAttachment|
                                subAttachment = Facebook::Attachment.new
                                subAttachment.id = attachmentCounter
                                attachmentCounter += 1
                                subAttachment.description = mnStPostSubAttachment.description
                                if mnStPostSubAttachment.media
                                    subAttachment.image_height = mnStPostSubAttachment.media.image.height
                                    subAttachment.image_src = mnStPostSubAttachment.media.image.src
                                    subAttachment.image_width = mnStPostSubAttachment.media.image.width
                                end
                                if mnStPostSubAttachment.target
                                    subAttachment.target_id = mnStPostSubAttachment.target.id
                                    subAttachment.target_url = mnStPostSubAttachment.target.url
                                end
                                subAttachment.title = mnStPostSubAttachment.title
                                subAttachment.attachment_type = mnStPostSubAttachment.type
                                subAttachment.url = mnStPostSubAttachment.url

                                attachment.subattachments << subAttachment
                            end
                        end

                        facebookPost.attachments << attachment
                    end
                end

                post = Poly::Post.new
                post.id = postCounter
                post.post_type = 'facebook'
                post.facebook_post = facebookPost
                
                @posts << post
                postCounter += 1
            end

            @posts.sort! { |a,b| b.get_submit_date <=> a.get_submit_date }
        end
end