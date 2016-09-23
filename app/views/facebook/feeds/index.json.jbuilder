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
        end
        json.likes post.likes do |like|
            json.id                 like.id
            json.name               like.name
        end
    end
end