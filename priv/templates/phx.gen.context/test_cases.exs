
  alias <%= inspect schema.module %>

  @valid_attrs <%= inspect schema.params.create %>
  @update_attrs <%= inspect schema.params.update %>
  @invalid_attrs <%= inspect for {key, _} <- schema.params.create, into: %{}, do: {key, nil} %>

  describe "#paginate_<%= schema.plural %>/1" do
    test "returns paginated list of <%= schema.plural %>" do
      for _ <- 1..20 do
        <%= schema.singular %>_fixture()
      end

      {:ok, %{<%= schema.plural %>: <%= schema.plural %>} = page} = <%= inspect context.alias %>.paginate_<%= schema.plural %>(%{})

      assert length(<%= schema.plural %>) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_<%= schema.plural %>/0" do
    test "returns all <%= schema.plural %>" do
      <%= schema.singular %> = <%= schema.singular %>_fixture()
      assert <%= inspect context.alias %>.list_<%= schema.plural %>() == [<%= schema.singular %>]
    end
  end

  describe "#get_<%= schema.singular %>!/1" do
    test "returns the <%= schema.singular %> with given id" do
      <%= schema.singular %> = <%= schema.singular %>_fixture()
      assert <%= inspect context.alias %>.get_<%= schema.singular %>!(<%= schema.singular %>.id) == <%= schema.singular %>
    end
  end

  describe "#create_<%= schema.singular %>/1" do
    test "with valid data creates a <%= schema.singular %>" do
      assert {:ok, %<%= inspect schema.alias %>{} = <%= schema.singular %>} = <%= inspect context.alias %>.create_<%= schema.singular %>(@valid_attrs)<%= for {field, value} <- schema.params.create do %>
      assert <%= schema.singular %>.<%= field %> == <%= Mix.Phoenix.Schema.value(schema, field, value) %><% end %>
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = <%= inspect context.alias %>.create_<%= schema.singular %>(@invalid_attrs)
    end
  end

  describe "#update_<%= schema.singular %>/2" do
    test "with valid data updates the <%= schema.singular %>" do
      <%= schema.singular %> = <%= schema.singular %>_fixture()
      assert {:ok, <%= schema.singular %>} = <%= inspect context.alias %>.update_<%= schema.singular %>(<%= schema.singular %>, @update_attrs)
      assert %<%= inspect schema.alias %>{} = <%= schema.singular %><%= for {field, value} <- schema.params.update do %>
      assert <%= schema.singular %>.<%= field %> == <%= Mix.Phoenix.Schema.value(schema, field, value) %><% end %>
    end

    test "with invalid data returns error changeset" do
      <%= schema.singular %> = <%= schema.singular %>_fixture()
      assert {:error, %Ecto.Changeset{}} = <%= inspect context.alias %>.update_<%= schema.singular %>(<%= schema.singular %>, @invalid_attrs)
      assert <%= schema.singular %> == <%= inspect context.alias %>.get_<%= schema.singular %>!(<%= schema.singular %>.id)
    end
  end

  describe "#delete_<%= schema.singular %>/1" do
    test "deletes the <%= schema.singular %>" do
      <%= schema.singular %> = <%= schema.singular %>_fixture()
      assert {:ok, %<%= inspect schema.alias %>{}} = <%= inspect context.alias %>.delete_<%= schema.singular %>(<%= schema.singular %>)
      assert_raise Ecto.NoResultsError, fn -> <%= inspect context.alias %>.get_<%= schema.singular %>!(<%= schema.singular %>.id) end
    end
  end

  describe "#change_<%= schema.singular %>/1" do
    test "returns a <%= schema.singular %> changeset" do
      <%= schema.singular %> = <%= schema.singular %>_fixture()
      assert %Ecto.Changeset{} = <%= inspect context.alias %>.change_<%= schema.singular %>(<%= schema.singular %>)
    end
  end

  def <%= schema.singular %>_fixture(attrs \\ %{}) do
    {:ok, <%= schema.singular %>} =
      attrs
      |> Enum.into(@valid_attrs)
      |> <%= inspect context.alias %>.create_<%= schema.singular %>()

    <%= schema.singular %>
  end

