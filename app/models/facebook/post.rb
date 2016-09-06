class Facebook::Post
    extend ActiveModel::Naming
    include ActiveModel::Model

    attr_accessor :id
    attr_accessor :name
    attr_accessor :created_time
    attr_accessor :from
    attr_accessor :link
    attr_accessor :picture
    attr_accessor :message
    attr_accessor :type
    attr_accessor :comments
    attr_accessor :likes

    def initialize
        self.id = 0
        self.name = ""
        self.created_time = nil
        self.from = nil
        self.link = ""
        self.picture = ""
        self.message = ""
        self.type = ""
        self.comments = []
        self.likes = []
    end
end
