defmodule Torch.TableViewTest do
  use ExUnit.Case, async: true
  import Phoenix.HTML, only: [safe_to_string: 1]
  import Torch.TableView
  
  doctest Torch.TableView, except: [flop_table_link: 3]
end

