class TasksController < ApplicationController
  require 'debug'

  before_action :logged_in_user, only: %i[index new create edit update destroy] # ログイン済みユーザーかどうか確認
  before_action :correct_user_id, only: %i[create update] # リクエストパラメーターのuser_idがログイン中のユーザーのものかどうか確認
  before_action :correct_users_task, only: %i[edit update destroy] # 正しいユーザーのタスクかどうか確認

  SORT_COLUMNS = %w[title finished created_at]
  DEFAULT_SORT_COLUMN = 'created_at'
  SORT_DIRECTIONS = %w[asc desc]
  DEFAULT_SORT_DIRECTION = 'desc'

  # 一覧画面（ログイン中のユーザーのタスクのみ表示する）
  def index
    @tasks = Task.where(user_id: @current_user.id).order("#{sort_column}")

    @sort_column = params[:sort_column]
    @sort_direction = params[:sort_direction] == 'asc' ? 'desc' : 'asc'
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
    params.require(:task).permit(:title, :finished, :user_id)
  end

  # リクエストパラメータのuser_idがログイン中のユーザーのものかどうか確認
  def correct_user_id
    if current_user.id != params[:task][:user_id].to_i
      flash[:danger] = 'リクエストが不正です。'
      redirect_to root_url, status: :see_other
    end
  end

  # 自分のタスク以外は編集・削除できないようにする
  def correct_users_task
    @task = Task.find(params[:id])
    if @task.user_id != current_user.id
      flash[:danger] = 'リクエストが不正です。'
      redirect_to root_url, status: :see_other
    end
  end

  # ソートするカラムと順序の指定（無効な値の場合はデフォルト値を返す）
  def sort_column
    if SORT_COLUMNS.include?(params[:sort_column]) && SORT_DIRECTIONS.include?(params[:sort_direction])
      "#{params[:sort_column]} #{params[:sort_direction]}"
    else
      "#{DEFAULT_SORT_COLUMN} #{DEFAULT_SORT_DIRECTION}"
    end
  end
end
