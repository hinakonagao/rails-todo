class SessionsController < ApplicationController
  def new
  end

  # ログイン処理
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_url
    else
      flash.now[:danger] = 'ログイン情報が正しくありません'
      render 'new', status: :unprocessable_entity
    end
  end

  # ログアウト処理
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
