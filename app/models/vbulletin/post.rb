class Vbulletin::Post
    extend ActiveModel::Naming
    include ActiveModel::Model

    attr_accessor :id
    attr_accessor :vbulletin_post_id
    attr_accessor :author
    attr_accessor :post_content
    attr_accessor :submit_date
    attr_accessor :forum
    attr_accessor :topic
    attr_accessor :quotes

    def initialize
        self.id = 0
        self.vbulletin_post_id = 0
        self.author = ""
        self.post_content = ""
        self.submit_date = nil
        self.forum = nil
        self.topic = nil
        self.quotes = []
    end
end
