class PostSerializer < ActiveModel::Serializer
    attributes :id, :vbulletin_post_id, :author, :content, :submit_date
end