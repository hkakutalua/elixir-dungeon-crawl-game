defmodule DungeonCrawl.CLI.Main do
  alias Mix.Shell.IO, as: Shell

  @initial_round_number 1

  def start_game do
    welcome_message()
    Shell.prompt("Press ENTER to continue")
    difficulty_level = DungeonCrawl.CLI.DifficultyLevelChoice.start()
    crawl(hero_choice(), difficulty_level, @initial_round_number)
  end

  defp welcome_message do
    Shell.info("== Dungeon Crawl ==")
    Shell.info("You awake in a dungeon full of monsters.")
    Shell.info("You need to survive and find the exit.")
  end

  defp hero_choice do
    hero = DungeonCrawl.CLI.HeroChoice.start()
    %{hero | name: "You"}
  end

  defp crawl(%{hit_points: 0}, _difficulty_level, _round_number) do
    Shell.prompt("")
    Shell.cmd("clear")
    Shell.info("Unfortunately your wounds are too many to keep walking.")
    Shell.info("You fall onto the floor without strength to carry on")
    Shell.info("Game over!")
    Shell.prompt("")
  end

  defp crawl(character, difficulty_level, round_number) do
    Shell.info("Round #{round_number}")
    Shell.info("You keep moving forward to the next room.")
    Shell.prompt("Press ENTER to continue")
    Shell.cmd("clear")

    Shell.info(DungeonCrawl.Character.current_stats(character))

    handle_action = &handle_action_result(&1, difficulty_level, round_number)

    DungeonCrawl.Room.all(difficulty_level, round_number)
    |> DungeonCrawl.Room.RoomChooser.choose_room
    |> DungeonCrawl.CLI.RoomActionsChoice.start
    |> trigger_action(character)
    |> handle_action.()
  end

  defp trigger_action({room, action}, character) do
    Shell.cmd("clear")
    room.trigger.run(character, action)
  end

  defp handle_action_result({_, :exit}, _difficulty_level, _round_number),
    do: Shell.info("You found the exit. You won the game. Congratulations!")
  defp handle_action_result({character, _}, difficulty_level, round_number),
    do: crawl(character, difficulty_level, round_number + 1)
end
