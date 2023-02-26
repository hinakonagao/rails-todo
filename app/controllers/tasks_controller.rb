class TasksController < ApplicationController
  # 一覧画面（ログイン中のユーザーのタスク）
  def index
    # TODO: ログイン中かどうかの判定
    @tasks = Task.where(user_id: current_user.id)
  end

  # タスク新規作成画面の表示
  def new
    # TODO: ログイン中かどうかの判定
    @task = Task.new # タスクのインスタンスを生成
    @current_user = current_user
  end

  # タスク新規作成処理
  def create
    @task = Task.create(task_params) # タスクのインスタンスを生成
    # TODO: user_idに一致するユーザーがいるのかの判定
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :user_id)
  end
end
