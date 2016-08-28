class ApplicationController < ActionController::API
    private
        def render_missing_url_parameter_json
            render :json => {
                :errors => [
                    {
                        :status => "422",
                        :source => "/v1/topics",
                        :title => "missing-parameter",
                        :detail => "URL parameter could not be found and is required"
                    }
                ]
            }.to_json,
            :status => 422
        end
end
