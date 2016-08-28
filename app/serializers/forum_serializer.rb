class ForumSerializer < ActiveModel::Serializer
    attributes :is_vbulletin, :vbulletin_version, :title, :url
end