module ApplicationHelper
	include Twitter::Autolink

	def extract_reply(text)
    regex_arr = [
      Regexp.new("From:\s*", Regexp::IGNORECASE | Regexp::MULTILINE),
      #Regexp.new("<>", Regexp::IGNORECASE | Regexp::MULTILINE),
      #Regexp.new(Regexp.escape(address) + "\s+wrote:", Regexp::IGNORECASE | Regexp::MULTILINE),
      #Regexp.new("^.*On.*(\n)?wrote:$", Regexp::IGNORECASE | Regexp::MULTILINE),
      #Regexp.new("\s\S*On\s\w*.\s.*", Regexp::IGNORECASE | Regexp::MULTILINE),
      Regexp.new("\\r\\n\\r\\n\\r\\nOn\s.*,\s.*offbott.com\swrote:.*", Regexp::IGNORECASE | Regexp::MULTILINE),
      Regexp.new("\\r\\nOn\s.*,\s.*offbott.com\swrote:.*", Regexp::IGNORECASE | Regexp::MULTILINE),
      Regexp.new("-+original\s+message-+\s*$", Regexp::IGNORECASE | Regexp::MULTILINE),
      Regexp.new("from:\s*$", Regexp::IGNORECASE | Regexp::MULTILINE)
    ]

    text_length = text.length
    #calculates the matching regex closest to top of page
    index = regex_arr.inject(text_length) do |min, regex|
      puts min
        [(text.index(regex) || text_length), min].min
    end

    text[0, index].strip
  end

end
