json.posts do
    json.array! @posts do |post|
        json.id                 post.id
        json.post_type          post.post_type
        json.facebook_post do
            if post.facebook_post
                json.id                 post.facebook_post.id 
                json.name               post.facebook_post.name
                json.created_time       post.facebook_post.created_time
                json.from               post.facebook_post.from
                json.permalink_url      post.facebook_post.permalink_url
                json.post_link          post.facebook_post.post_link
                json.picture            post.facebook_post.picture
                json.full_picture       post.facebook_post.full_picture
                json.message            post.facebook_post.message
                json.post_type               post.facebook_post.type
                json.comments post.facebook_post.comments do |comment|
                    json.id                 comment.id
                    json.from               comment.from
                    json.message            comment.message
                    if comment.attachment
                        json.attachment do
                            json.id                 comment.attachment.id
                            json.description        comment.attachment.description
                            json.image_height       comment.attachment.image_height
                            json.image_src          comment.attachment.image_src
                            json.image_width        comment.attachment.image_width
                            json.target_id          comment.attachment.target_id
                            json.target_url         comment.attachment.target_url
                            json.title              comment.attachment.title
                            json.attachment_type    comment.attachment.attachment_type
                            json.url                comment.attachment.url
                        end
                    end
                    json.comments comment.comments do |commentComment|
                        json.id                 commentComment.id
                        json.from               commentComment.from
                        json.message            commentComment.message
                        if commentComment.attachment
                            json.attachment do
                                json.id                 commentComment.attachment.id
                                json.description        commentComment.attachment.description
                                json.image_height       commentComment.attachment.image_height
                                json.image_src          commentComment.attachment.image_src
                                json.image_width        commentComment.attachment.image_width
                                json.target_id          commentComment.attachment.target_id
                                json.target_url         commentComment.attachment.target_url
                                json.title              commentComment.attachment.title
                                json.attachment_type    commentComment.attachment.attachment_type
                                json.url                commentComment.attachment.url
                            end
                        end
                    end
                end
                json.likes post.facebook_post.likes do |like|
                    json.id                 like.id
                    json.name               like.name
                end
                json.attachments post.facebook_post.attachments do |attachment|
                    json.id                 attachment.id
                    json.description        attachment.description
                    json.image_height       attachment.image_height
                    json.image_src          attachment.image_src
                    json.image_width        attachment.image_width
                    json.target_id          attachment.target_id
                    json.target_url         attachment.target_url
                    json.title              attachment.title
                    json.attachment_type    attachment.attachment_type
                    json.url                attachment.url
                    json.subattachments attachment.subattachments do |subattachment|
                        json.id                 subattachment.id
                        json.description        subattachment.description
                        json.image_height       subattachment.image_height
                        json.image_src          subattachment.image_src
                        json.image_width        subattachment.image_width
                        json.target_id          subattachment.target_id
                        json.target_url         subattachment.target_url
                        json.title              subattachment.title
                        json.attachment_type    subattachment.attachment_type
                        json.url                subattachment.url
                    end
                end
            end
        end
        json.vbulletin_post do
            if post.vbulletin_post
                json.id                     post.vbulletin_post.id
                json.post_permalink         post.vbulletin_post.post_permalink
                json.vbulletin_post_id      post.vbulletin_post.vbulletin_post_id
                json.author                 post.vbulletin_post.author
                json.post_content           post.vbulletin_post.post_content
                json.submit_date            post.vbulletin_post.submit_date
                json.forum do
                    json.id                 post.vbulletin_post.forum.id
                    json.is_vbulletin       post.vbulletin_post.forum.is_vbulletin
                    json.vbulletin_version  post.vbulletin_post.forum.vbulletin_version
                    json.title              post.vbulletin_post.forum.title
                    json.url                post.vbulletin_post.forum.url
                end
                json.topic do
                    json.id                 post.vbulletin_post.topic.id
                    json.title              post.vbulletin_post.topic.title
                    json.url                post.vbulletin_post.topic.url
                end
                json.quotes post.vbulletin_post.quotes do |quote|
                    json.id                 quote.id
                    json.author             quote.author
                    json.quote_content      quote.quote_content
                end
            end
        end
    end
end