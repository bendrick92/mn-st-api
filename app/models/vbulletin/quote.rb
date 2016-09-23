class Vbulletin::Quote
    extend ActiveModel::Naming
    include ActiveModel::Model

    attr_accessor :id
    attr_accessor :author
    attr_accessor :quote_content

    def initialize
        self.id = 0
        self.author = ''
        self.quote_content = ''
    end
end