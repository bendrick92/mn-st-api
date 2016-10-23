class Facebook::Post
    extend ActiveModel::Naming
    include ActiveModel::Model

    attr_accessor :id
    attr_accessor :name
    attr_accessor :created_time
    attr_accessor :from
    attr_accessor :post_link
    attr_accessor :picture
    attr_accessor :full_picture
    attr_accessor :message
    attr_accessor :type
    attr_accessor :comments
    attr_accessor :likes
    attr_accessor :permalink_url
    attr_accessor :attachments

    def initialize
        self.id = 0
        self.name = ""
        self.created_time = nil
        self.from = nil
        self.post_link = ""
        self.picture = ""
        self.full_picture = ""
        self.message = ""
        self.type = ""
        self.comments = []
        self.likes = []
        self.permalink_url = ""
        self.attachments = []
    end
end
