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
                json.post_link          post.facebook_post.post_link
                json.picture            post.facebook_post.picture
                json.full_picture       post.facebook_post.full_picture
                json.message            post.facebook_post.message
                json.post_type               post.facebook_post.type
                json.comments post.facebook_post.comments do |comment|
                    json.id                 comment.id
                    json.from               comment.from
                    json.message            comment.message
                    json.comments comment.comments do |commentComment|
                        json.id                 commentComment.id
                        json.from               commentComment.from
                        json.message            commentComment.message
                    end
                end
                json.likes post.facebook_post.likes do |like|
                    json.id                 like.id
                    json.name               like.name
                end
            end
        end
        json.vbulletin_post do
            if post.vbulletin_post
                json.id                     post.vbulletin_post.id
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