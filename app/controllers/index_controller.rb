class IndexController < ApplicationController
  def index
  end

  def ranking
    data = client.ranking(params[:category])
    @contents = data.contents
  end

  def search
    data = client.search(params)
    @contents = data.contents
  end

  def content
    @cont_id = params[:cont_id]
    data = client.content(@cont_id)
    @content = data.content
  end

  def auth
    return unless request.post?
    begin
      auth = TINAMI.auth params[:email], params[:password]
      session[:auth_key] = auth.auth_key
      redirect_to :index
    rescue TINAMI::Error => e
      if request.xhr?
        render text: e.message, status: 400
      else
        flash[:notice] = e.message
      end
    end
  end

  def logout
    begin
      TINAMI.logout auth_key: session.delete(:auth_key)
    rescue TINAMI::Error => e
      logger.info e
    end
    redirect_to :index
  end

end
