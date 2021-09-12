defmodule Tests.EdgeDB.Protocol.Codecs.Builtin.SetTest do
  use EdgeDB.Case

  setup :edgedb_connection

  test "decoding set value", %{conn: conn} do
    value = new_set([1, 2, 3])
    assert {:ok, ^value} = EdgeDB.query(conn, "SELECT {1, 2, 3}")
  end

  defp new_set(elements) do
    %EdgeDB.Set{__items__: MapSet.new(elements)}
  end
end