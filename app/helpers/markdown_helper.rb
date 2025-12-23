module MarkdownHelper
  class HTMLWithRouge < Redcarpet::Render::HTML
    def block_code(code, language)
      if language.present?
        formatter = Rouge::Formatters::HTML.new
        lexer = Rouge::Lexer.find(language) || Rouge::Lexers::PlainText.new
        formatted_code = formatter.format(lexer.lex(code))
        "<div class=\"code-block\"><pre><code class=\"language-#{language}\">#{formatted_code}</code></pre></div>"
      else
        "<div class=\"code-block\"><pre><code>#{ERB::Util.html_escape(code)}</code></pre></div>"
      end
    end
  end

  def markdown(text)
    return "" if text.blank?

    renderer = HTMLWithRouge.new(
      filter_html: false,
      hard_wrap: true,
      link_attributes: { target: "_blank", rel: "noopener noreferrer" }
    )

    markdown = Redcarpet::Markdown.new(renderer,
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

    sanitize(markdown.render(text), tags: %w[p br strong em del code pre a ul ol li blockquote h1 h2 h3 h4 h5 h6 div span], attributes: %w[href target rel class])
  end
end
