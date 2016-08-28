class ForumSerializer < ActiveModel::Serializer
    attributes :id, :is_vbulletin, :vbulletin_version, :title, :url
end