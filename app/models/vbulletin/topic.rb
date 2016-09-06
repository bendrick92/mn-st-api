class Vbulletin::Topic
    extend ActiveModel::Naming
    include ActiveModel::Model

    attr_accessor :id
    attr_accessor :title
    attr_accessor :url
    attr_accessor :forum
    attr_accessor :posts

    def initialize
        self.id = 0
        self.title = ""
        self.url = ""
        self.forum = nil
        self.posts = []
    end
end
