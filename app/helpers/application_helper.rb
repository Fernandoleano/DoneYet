module ApplicationHelper
  def greeting_for_time_of_day
    hour = Time.current.hour

    case hour
    when 5..11
      "Good morning"
    when 12..17
      "Good afternoon"
    when 18..21
      "Good evening"
    else
      "Good evening" # Late night/early morning
    end
  end

  def markdown(text)
    return "" if text.blank?

    begin
      # Detect and convert Giphy GIF URLs to markdown image syntax
      # Match any line that contains a media.giphy.com URL
      text = text.gsub(%r{https?://media\d*\.giphy\.com/[^\s]+}i) do |url|
        "\n![GIF](#{url})\n"
      end

      # Handle any other .gif URLs
      text = text.gsub(%r{https?://[^\s]+\.gif[^\s]*}i) do |url|
        "\n![GIF](#{url})\n"
      end

      renderer = ApplicationHelper::MarkdownRenderer.new(
        filter_html: false,
        hard_wrap: true,
        link_attributes: { target: "_blank", rel: "noopener noreferrer" }
      )

      markdown_processor = Redcarpet::Markdown.new(renderer,
        autolink: true,
        tables: true,
        fenced_code_blocks: true,
        strikethrough: true,
        superscript: true,
        underline: true,
        highlight: true,
        quote: true,
        no_intra_emphasis: true,
        space_after_headers: true
      )

      sanitize(markdown_processor.render(text), tags: %w[p br strong em del code pre a ul ol li blockquote h1 h2 h3 h4 h5 h6 div span img], attributes: %w[href target rel class src alt])
    rescue => e
      Rails.logger.error "Markdown rendering error: #{e.message}"
      ERB::Util.html_escape(text)
    end
  end

  class MarkdownRenderer < Redcarpet::Render::HTML
    def block_code(code, language)
      if language.present?
        begin
          formatter = Rouge::Formatters::HTML.new
          lexer = Rouge::Lexer.find(language) || Rouge::Lexers::PlainText.new
          formatted_code = formatter.format(lexer.lex(code))
          "<div class=\"code-block\"><pre><code class=\"language-#{language}\">#{formatted_code}</code></pre></div>"
        rescue
          "<div class=\"code-block\"><pre><code>#{ERB::Util.html_escape(code)}</code></pre></div>"
        end
      else
        "<div class=\"code-block\"><pre><code>#{ERB::Util.html_escape(code)}</code></pre></div>"
      end
    end
  end
end
