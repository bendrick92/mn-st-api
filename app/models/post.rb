class Post
    extend ActiveModel::Naming
    include ActiveModel::Model
    include ActiveModel::Serialization

    attr_accessor :vbulletin_post_id
    attr_accessor :author
    attr_accessor :content
    attr_accessor :submit_date

    def initialize
        self.vbulletin_post_id = 0
        self.author = ""
        self.content = ""
        self.submit_date = nil
    end
end
