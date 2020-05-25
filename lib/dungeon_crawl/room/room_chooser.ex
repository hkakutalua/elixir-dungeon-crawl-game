defmodule DungeonCrawl.Room.RoomChooser do
  def choose_room(rooms) do
    probabilities = Enum.map(rooms, fn room -> room.probability end)

    sum_of_probabilities = Enum.reduce(probabilities, 0, &+/2)
    prefixes = build_prefixes_of_probabilities(probabilities)

    random_number = :rand.uniform(sum_of_probabilities)
    random_number_ceil_index = get_number_ceil_index(random_number, prefixes)

    Enum.at(rooms, random_number_ceil_index)
  end

  defp get_number_ceil_index(number, prefixes) do
    get_number_ceil_index(number, prefixes, 0)
  end

  defp get_number_ceil_index(_number, [], index), do: index
  defp get_number_ceil_index(_number, [_], index), do: index
  defp get_number_ceil_index(number, [head | tail], index) when number > head do
    get_number_ceil_index(number, tail, index + 1)
  end
  defp get_number_ceil_index(_number, _prefixes, index), do: index

  defp build_prefixes_of_probabilities([]), do: []
  defp build_prefixes_of_probabilities([x]), do: [x]
  defp build_prefixes_of_probabilities([head, second | tail]) do
    [head | build_prefixes_of_probabilities([head + second | tail])]
  end
end
