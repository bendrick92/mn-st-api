class Forum
    extend ActiveModel::Naming
    include ActiveModel::Model
    include ActiveModel::Serialization

    attr_accessor :is_vbulletin
    attr_accessor :vbulletin_version
    attr_accessor :title
    attr_accessor :url

    def initialize
        self.is_vbulletin = false
        self.vbulletin_version = ""
        self.title = ""
        self.url = ""
    end
end
