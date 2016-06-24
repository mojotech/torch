# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Example.Repo.insert!(Example.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Example.{
  Author,
  Post,
  Repo
}

author = Repo.insert! %Author{name: "John Smith", email: "john@smith.com"}

for _ <- 1..50 do
  Repo.insert! %Post{title: "My first blog post", body: "Some body test here", author_id: author.id}
end
