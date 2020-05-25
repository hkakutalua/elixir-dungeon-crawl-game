defmodule DungeonCrawl.Room do
  alias DungeonCrawl.Room
  alias DungeonCrawl.Room.Triggers

  import DungeonCrawl.Room.Action

  defstruct description: nil,
            actions: [],
            trigger: nil,
            probability: 0..10

  def all(difficulty_level, rounds) do
    enemy_probabilities_by_level = [easy: 5, medium: 6, hard: 8]
    healing_probabilities_by_level = [easy: 2, medium: 2, hard: 1]

    [
      %Room{
        description: "You can see the light of the day. You found the exit!",
        actions: [forward()],
        trigger: Triggers.Exit,
        probability: exit_probability_by_rounds(rounds)
      },
      %Room{
        description: "You can see the enemy blocking your path.",
        actions: [forward()],
        trigger: Triggers.Enemy,
        probability: choose_probability_by_level(difficulty_level, enemy_probabilities_by_level)
      },
      %Room{
        description: "You entered the healing room",
        actions: [rest(), forward()],
        trigger: Triggers.Healing,
        probability: choose_probability_by_level(difficulty_level, healing_probabilities_by_level)
      }
    ]
  end

  defp exit_probability_by_rounds(rounds) do
    if(rounds <= 2, do: 1, else: Kernel.trunc(min(10, rounds * 0.8)))
  end

  defp choose_probability_by_level(_difficulty_level, []), do: nil
  defp choose_probability_by_level(difficulty_level, [{level, probability} = _head | _tail])
    when level == difficulty_level, do: probability
  defp choose_probability_by_level(difficulty_level, [_head | tail]) do
    choose_probability_by_level(difficulty_level, tail)
  end
end
