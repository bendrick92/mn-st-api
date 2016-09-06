class Facebook::User
    extend ActiveModel::Naming
    include ActiveModel::Model

    attr_accessor :id
    attr_accessor :name

    def initialize
        self.id = 0
        self.name = ""
    end
end
