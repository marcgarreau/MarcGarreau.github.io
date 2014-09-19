module Jekyll
  class TerminalTag < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super
    end

    def render(context)
		  output = super(context)
		  terminal_window promptize(output)
		end

		def terminal_window(output)
		  %{<div class="window">
		      <nav class="control-window">
		        <a href="#" class="close">close</a>
		        <a href="#" class="minimize">minimize</a>
		        <a href="#" class="deactivate">deactivate</a>
		      </nav>
		      <h1 class="titleInside">Terminal</h1>
		      <div class="container">
		        <div class="terminal">#{output}</div>
		      </div>
		    </div>}
		end

		def promptize(content)
		  lines_of_content = content.strip.lines
		  gutters = lines_of_content.map { |line| gutter(line) }
		  lines_of_code = lines_of_content.map { |line| line_of_code(line) }

		  table = "<table><tr>"
		  table += "<td class='gutter'><pre class='line-numbers'>#{gutters.join("\n")}</pre></td>"
		  table += "<td class='code'><pre><code>#{lines_of_code.join("")}</code></pre></td>"
		  table += "</tr></table>"
		end

		def command_character
		  "$"
		end

		def gutter(line)
		  gutter_value = line.start_with?(command_character) ? command_character : "&nbsp;"
		  "<span class='line-number'>#{gutter_value}</span>"
		end

		def line_of_code(line)
		  if line.start_with?(command_character)
		    line_class = "command"
		    line = line.sub(command_character,'').strip
		  else
		    line_class = "output"
		  end
		  "<span class='line #{line_class}'>#{line}</span>"
		end
  end
end

Liquid::Template.register_tag('terminal', Jekyll::TerminalTag)