class Facebook::Comment
    extend ActiveModel::Naming
    include ActiveModel::Model

    attr_accessor :id
    attr_accessor :from
    attr_accessor :message
    attr_accessor :comments
    attr_accessor :attachment

    def initialize
        self.id = 0
        self.from = nil
        self.message = ""
        self.comments = []
        self.attachment = nil
    end
end
