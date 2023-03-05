class AddFiishedToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :finished, :boolean, default: false, after: :title
  end
end
