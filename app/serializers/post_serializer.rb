class PostSerializer < ActiveModel::Serializer
    attributes :vbulletin_post_id, :author, :content, :submit_date
end