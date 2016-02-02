defmodule BNote.Booknames do
  def to_full(short) do
    short = String.strip short
    matches =
      all
      |> Enum.filter(&String.starts_with?(&1, short))
    case length(matches) do
      1 -> {:ok, Enum.at(matches,0)}
      0 -> {:err, :no_match}
      _ -> {:ambiguous, matches}
    end
  end

  def all do
    [
      "1chronicles",
      "1corinthians",
      "1john",
      "1kings",
      "1peter",
      "1samuel",
      "1thessalonians",
      "1timothy",
      "2chronicles",
      "2corinthians",
      "2john",
      "2kings",
      "2peter",
      "2samuel",
      "2thessalonians",
      "2timothy",
      "3john",
      "acts",
      "amos",
      "books",
      "colossians",
      "daniel",
      "deuteronomy",
      "ecclesiastes",
      "ephesians",
      "esther",
      "exodus",
      "ezekiel",
      "ezra",
      "galatians",
      "genesis",
      "habakkuk",
      "haggai",
      "hebrews",
      "hosea",
      "isaiah",
      "james",
      "jeremiah",
      "job",
      "joel",
      "john",
      "jonah",
      "joshua",
      "jude",
      "judges",
      "lamentations",
      "leviticus",
      "luke",
      "malachi",
      "mark",
      "matthew",
      "micah",
      "nahum",
      "nehemiah",
      "numbers",
      "obadiah",
      "philemon",
      "philippians",
      "proverbs",
      "psalms",
      "revelation",
      "romans",
      "ruth",
      "songofsolomon",
      "titus",
      "zechariah",
      "zephaniah"
    ]
  end

end