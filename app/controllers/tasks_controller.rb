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

  # タスク編集画面の表示
  def edit
    @task = Task.find(params[:id]) # リクエストURL内{id}部分の数値をparams[:id]で取り出す
    # TODO: 不正なidを指定された場合の処理
  end

  # タスクの更新
  def update
    @task = Task.find(params[:id])
    @task.update(task_params)
    redirect_to tasks_url
  end

  private

  def task_params
    params.require(:task).permit(:title, :user_id)
  end
end
