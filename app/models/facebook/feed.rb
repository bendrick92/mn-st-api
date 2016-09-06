class Facebook::Feed
    extend ActiveModel::Naming
    include ActiveModel::Model

    attr_accessor :id
    attr_accessor :posts

    def initialize
        self.id = 0
        self.posts = []
    end
end
