class TasksController < ApplicationController
  require 'debug'

  before_action :logged_in_user, only: %i[index new create edit update] # ログイン済みユーザーかどうか確認
  before_action :correct_user, only: %i[create] # ログイン済みユーザーかどうか確認

  # 一覧画面（ログイン中のユーザーのタスク）
  def index
    @tasks = Task.where(user_id: current_user.id)
  end

  # タスク新規作成画面の表示
  def new
    @task = Task.new # タスクのインスタンスを生成
    @current_user = current_user
  end

  # タスク新規作成処理
  def create
    @task = Task.new(task_params) # タスクのインスタンスを生成
    if @task.save
      redirect_to root_url
    else
      render 'new', status: :unprocessable_entity
    end
  end

  # タスク編集画面の表示
  def edit
    @task = Task.find_by(id: params[:id]) # リクエストURL内{id}部分の数値をparams[:id]で取り出す
    if !@task || @task.user_id != current_user.id
      flash[:danger] = 'リクエストが不正です。'
      redirect_to root_url, status: :see_other
    end
  end

  # タスクの更新
  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_url
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  # タスクの削除
  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      redirect_to tasks_url, status: :see_other
    else
      render 'index', status: :unprocessable_entity
    end
  end

  private

  # Strong Parameter
  def task_params
    params.require(:task).permit(:title, :user_id)
  end

  # 正しいユーザーかどうか確認
  def correct_user
    if current_user.id != params[:task][:user_id].to_i
      flash[:danger] = 'リクエストが不正です。'
      redirect_to root_url, status: :see_other
    end
  end
end
