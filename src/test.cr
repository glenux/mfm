require "unibilium"
require "tput"

terminfo = Unibilium::Terminfo.from_env
tput = Tput.new terminfo

# Print detected features and environment
p tput.features.to_json
p tput.emulator.to_json

# Set terminal emulator's title, if possible
tput.title = "Test 123"

# Set cursor to red block:
tput.cursor_shape Tput::CursorShape::Block, blink: false
tput.cursor_color Tput::Color::Red

# Switch to "alternate buffer", print some text
tput.alternate
tput.cursor_pos 10, 20
tput.echo "Text at position y=10, x=20"
tput.bell
tput.cr
tput.lf

tput.echo "Now displaying ACS chars:"
tput.cr
tput.lf
tput.smacs
tput.echo "``aaffggiijjkkllmmnnooppqqrrssttuuvvwwxxyyzz{{||}}~~"
tput.rmacs

tput.cr
tput.lf
tput.echo "Press any keys; q to exit."

# Listen for keypresses:
tput.listen do |char, key, sequence|
  # Char is a single typed character, or the first character
  # of a sequence which led to a particular key.

  # Key is a keyboard key, if any. Ordinary characters like
  # 'a' or '1' don't have a representation as Key. Special
  # keys like Enter, F1, Esc etc. do.

  # Sequence is the complete sequence of characters which
  # were consumed as part of identifying the key that was
  # pressed.
  if char == 'q'
    tput.normal_buffer
    # tput.reset_cursor
    # tput.exit_alt_charset_mode
    # tput.attr("normal", 1)
    # tput.soft_reset
    system("stty echo")
    exit
  else
    tput.cr
    tput.lf
    tput.echo "Char=#{char.inspect}, Key=#{key.inspect}, Sequence=#{sequence.inspect}"
  end
end

