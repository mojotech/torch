defmodule MockRepo do
  use Ecto.Repo,
    otp_app: :torch,
    adapter: Ecto.Adapters.Postgres
end

defmodule MockModel do
  use Ecto.Schema

  schema "mocks" do
    field(:uuid, :binary_id)
    field(:title, :string)
    field(:body, :string)
    field(:published_at, :naive_datetime)
    field(:view_count, :integer)
    field(:tags, {:array, :string})
    field(:archived, :boolean, default: false)
    field(:status, Ecto.Enum, values: [:unpublished, :published, :deleted])

    timestamps()
  end
end

defmodule SmallMockModel do
  use Ecto.Schema

  schema "small_mocks" do
    field(:title, :string)
    field(:body, :string)
  end
end

defmodule NoAttrsMockModel do
  use Ecto.Schema

  schema "no_mocks" do
    field(:category, Ecto.Enum, values: [:small, :medium, :large])
  end
end

defmodule MockContext do
  import Ecto.Query, warn: false

  use Torch.Pagination,
    repo: MockRepo,
    model: MockModel,
    name: :mocks
end

defmodule MultiMockContext do
  import Ecto.Query, warn: false

  use Torch.Pagination,
    repo: MockRepo,
    model: SmallMockModel,
    name: :small_mocks

  use Torch.Pagination,
    repo: MockRepo,
    model: NoAttrsMockModel,
    name: :no_mocks
end

defmodule PaginationTest do
  use ExUnit.Case

  test "Ensure public paginate_* method exists" do
    function_exported?(MockContext, :filter_config, 1)
    function_exported?(MockContext, :paginate_mocks, 0)
    function_exported?(MockContext, :paginate_mocks, 1)
    function_exported?(MultiMockContext, :filter_config, 1)
    function_exported?(MultiMockContext, :paginate_small_mocks, 0)
    function_exported?(MultiMockContext, :paginate_small_mocks, 1)
    function_exported?(MultiMockContext, :paginate_no_mocks, 0)
    function_exported?(MultiMockContext, :paginate_no_mocks, 1)
  end

  test "Ensure we have Fitrex configuration for each key type" do
    assert 4 == length(MockContext.filter_config(:mocks))
    assert 4 == length(MultiMockContext.filter_config(:small_mocks))
    assert 4 == length(MultiMockContext.filter_config(:no_mocks))
  end

  test "ensure proper attributes list for filter types" do
    for %Filtrex.Type.Config{type: t, keys: attr_keys} <- MockContext.filter_config(:mocks) do
      case t do
        :text ->
          assert ~w(body title) == Enum.sort(attr_keys)

        :number ->
          assert ~w(id view_count) == Enum.sort(attr_keys)

        :boolean ->
          assert ~w(archived) == Enum.sort(attr_keys)

        :date ->
          assert ~w(inserted_at published_at updated_at) == Enum.sort(attr_keys)
      end
    end

    for %Filtrex.Type.Config{type: t, keys: attr_keys} <-
          MultiMockContext.filter_config(:small_mocks) do
      case t do
        :text ->
          assert ~w(body title) == Enum.sort(attr_keys)

        :number ->
          assert ~w(id) == attr_keys

        :boolean ->
          assert [] == attr_keys

        :date ->
          assert [] == attr_keys
      end
    end

    for %Filtrex.Type.Config{type: t, keys: attr_keys} <-
          MultiMockContext.filter_config(:no_mocks) do
      case t do
        :text ->
          assert [] == attr_keys

        :number ->
          assert ~w(id) == attr_keys

        :boolean ->
          assert [] == attr_keys

        :date ->
          assert [] == attr_keys
      end
    end
  end
end
