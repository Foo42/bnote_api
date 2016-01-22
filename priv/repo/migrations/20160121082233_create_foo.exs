defmodule BNote.Repo.Migrations.CreateFoo do
  use Ecto.Migration

  def change do
    create table(:foo) do
      add :body, :string
      add :book, :string
      add :chapter, :integer
      add :verse, :integer

      timestamps
    end

  end
end
