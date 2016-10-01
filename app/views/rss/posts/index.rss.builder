xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
    xml.channel do
        xml.title "MN STs - Latest Posts"
        xml.link "http://www.mnstoc/posts"
        xml.description "Aggregated posts from the MN STs Facebook group and associated forum threads"
        xml.language "en"

        @posts.each do |post|
            xml.item do
                if post.facebook_post
                    xml.title "Facebook - MN STs"
                    xml.pubDate post.facebook_post.created_time
                    xml.link post.facebook_post.permalink_url
                    xml.description post.facebook_post.message
                    xml.author post.facebook_post.from.name
                elsif post.vbulletin_post
                    xml.title post.vbulletin_post.forum.title + " - " + post.vbulletin_post.topic.title
                    xml.pubDate post.vbulletin_post.submit_date
                    xml.link post.vbulletin_post.post_permalink
                    xml.description post.vbulletin_post.post_content
                    xml.author post.vbulletin_post.author
                end
            end
        end
    end
end