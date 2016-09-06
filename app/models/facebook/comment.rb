class Facebook::Comment
    extend ActiveModel::Naming
    include ActiveModel::Model

    attr_accessor :id
    attr_accessor :from
    attr_accessor :message

    def initialize
        self.id = 0
        self.from = nil
        self.message = ""
    end
end
