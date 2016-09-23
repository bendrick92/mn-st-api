class Poly::Post
    extend ActiveModel::Naming
    include ActiveModel::Model

    attr_accessor :id
    attr_accessor :post_type
    attr_accessor :facebook_post
    attr_accessor :vbulletin_post

    def initialize
        self.id = 0
        self.post_type = ''
        self.facebook_post = nil
        self.vbulletin_post = nil
    end

    def get_submit_date
        if facebook_post
            return facebook_post.created_time
        elsif vbulletin_post
            return vbulletin_post.submit_date
        end
    end
end