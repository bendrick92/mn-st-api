json.topic do
    json.id             @topic.id
    json.title          @topic.title
    json.url            @topic.url
    json.forum do
        json.id                 @topic.forum.id
        json.is_vbulletin       @topic.forum.is_vbulletin
        json.vbulletin_version  @topic.forum.vbulletin_version
        json.title              @topic.forum.title
        json.url                @topic.forum.url
    end
    json.posts @topic.posts do |post|
        json.id                 post.id
        json.submit_date        post.submit_date
        json.vbulletin_post_id  post.vbulletin_post_id
        json.author             post.author
        json.post_content       post.post_content
        json.quotes post.quotes do |quote|
            json.id                     quote.id
            json.author                 quote.author
            json.quote_content          quote.quote_content
        end
    end
end