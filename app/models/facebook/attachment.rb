class Facebook::Attachment
    extend ActiveModel::Naming
    include ActiveModel::Model

    attr_accessor :id
    attr_accessor :description
    attr_accessor :image_height
    attr_accessor :image_src
    attr_accessor :image_width
    attr_accessor :target_id
    attr_accessor :target_url
    attr_accessor :title
    attr_accessor :attachment_type
    attr_accessor :url
    attr_accessor :subattachments

    def initialize
        self.id = 0
        self.description = ""
        self.image_height = 0
        self.image_src = ""
        self.image_width = 0
        self.target_id = 0
        self.target_url = ""
        self.title = ""
        self.attachment_type = ""
        self.url = ""
        self.subattachments = []
    end
end
