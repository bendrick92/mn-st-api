json.feed do
    json.id                 @feed.id
    json.posts @feed.posts do |post|
        json.id                 post.id
        json.name               post.name
        json.created_time       post.created_time
        json.from               post.from
        json.post_link          post.post_link
        json.picture            post.picture
        json.message            post.message
        json.post_type               post.type
        json.comments post.comments do |comment|
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
        json.likes post.likes do |like|
            json.id                 like.id
            json.name               like.name
        end
        json.attachments post.attachments do |attachment|
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