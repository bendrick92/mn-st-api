class Topic
    extend ActiveModel::Naming
    include ActiveModel::Model
    include ActiveModel::Serialization

    attr_accessor :id
    attr_accessor :title
    attr_accessor :url

    def initialize
        self.id = 0
        self.title = ""
        self.url = ""
    end
end
