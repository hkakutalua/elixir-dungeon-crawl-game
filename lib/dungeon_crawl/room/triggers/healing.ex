defmodule DungeonCrawl.Room.Triggers.Healing do
  @behaviour DungeonCrawl.Room.Trigger

  alias Mix.Shell.IO, as: Shell
  alias DungeonCrawl.Character

  def run(character, %DungeonCrawl.Room.Action{id: :rest}) do
    Shell.info("You found a healing potion")
    updated_character = Character.heal(character, 10)
    Shell.info(Character.current_stats(updated_character))
    {updated_character, :forward}
  end

  def run(character, %DungeonCrawl.Room.Action{id: :forward}) do
    {character, :forward}
  end
end
