defmodule DungeonCrawl.CLI.DifficultyLevelChoice do
  alias Mix.Shell.IO, as: Shell
  import DungeonCrawl.CLI.BaseCommands

  def start do
    Shell.cmd("clear")
    Shell.info("Choose your level of difficulty:")

    difficulties = [:easy, :medium, :hard]
    get_difficulty_by_index = &Enum.at(difficulties, &1)

    difficulties
    |> display_options
    |> generate_question
    |> Shell.prompt
    |> parse_answer
    |> get_difficulty_by_index.()
    |> confirm_difficulty
  end

  defp confirm_difficulty(difficulty) do
    Shell.cmd("clear")
    Shell.info("Chosen difficulty: #{difficulty}")
    if Shell.yes?("Confirm?"), do: difficulty, else: start()
  end
end
