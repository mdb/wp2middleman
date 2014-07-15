require 'spec_helper'

describe WP2Middleman::MiddlemanPost do
  let(:post_one) { double :post,
    title: "A Title",
    date_published: Date.new(2012,6,8).to_s,
    content: "Paragraph one.\n\n      Paragraph two.\n    ",
    tags: [],
    published?: true
  }

  let(:post_two) { double :post,
    title: "A second title",
    date_published: Date.new(2011,7,25).to_s,
    content: " <strong>Foo</strong>",
    tags: ["some_tag", "another tag", "tag"],
    published?: true
  }

  let(:post_three) { double :post,
    title: "A third title: With colon",
    date_published: Date.new(2011,7,26).to_s,
    content: "Foo",
    tags: ["some_tag", "another tag", "tag"],
    published?: false
  }

  let(:post_with_iframe) { double :post,
    title: "A fourth item with iframe and comment",
    date_published: Date.new(2011,7,26).to_s,
    content: "Here's a post with an iframe and a comment.\n\n<!--more-->\n\n<iframe width=\"400\" height=\"100\" style=\"position: relative; display: block; width: 400px; height: 100px;\" src=\"http://bandcamp.com/EmbeddedPlayer/v=2/track=833121761/size=venti/bgcol=FFFFFF/linkcol=4285BB/\" allowtransparency=\"true\" frameborder=\"0\"><a href=\"http://dihannmoore.bandcamp.com/track/you-do-it-for-me\">&quot;YOU DO IT FOR ME&quot; by DIHANN MOORE</a></iframe>",
    tags: ["some_tag", "another tag", "tag"],
    published?: false
  }

  it "has a title formatted for a filename" do
    wp_post = double :post, title: "A Title"
    post = WP2Middleman::MiddlemanPost.new(wp_post)

    expect(post.title_for_filename).to eq "A-Title"
  end

  it "removes odd characters (like colons) from title for filename" do
    wp_post = double :post, title: "A third title: With colon"
    post = WP2Middleman::MiddlemanPost.new(wp_post)

    expect(post.title_for_filename).to eq "A-third-title-With-colon"
  end

  it "prepends the date published onto the title for the filename" do
    wp_post = double :post, title: "A Title", date_published: Date.new(2012,6,8)
    post = WP2Middleman::MiddlemanPost.new(wp_post)

    expect(post.filename).to eq "2012-06-08-A-Title"
  end

  it "returns the full filename for a Middleman-style markdown post" do
    wp_post = double :post, title: "A Title", date_published: Date.new(2012,6,8)
    post = WP2Middleman::MiddlemanPost.new(wp_post)

    expect(post.full_filename('/some/path/')).to eq("/some/path/2012-06-08-A-Title.html.markdown")
  end

  it "converts the content to markdown" do
    wp_post = double :post, content: "<strong>Foo</strong>"
    post = WP2Middleman::MiddlemanPost.new(wp_post)

    expect(post.markdown_content).to eq "**Foo**"
  end

  it "has no formatting change to post body by default" do
    post = WP2Middleman::MiddlemanPost.new post_one

    expect(post.file_content).to eq(
      "---\ntitle: A Title\ndate: '2012-06-08'\ntags: []\n---\n\nParagraph one.\n\n      Paragraph two.\n    \n"
    )
  end

  it "formats the post body as markdown" do
    post = WP2Middleman::MiddlemanPost.new post_two, body_to_markdown: true

    expect( post.file_content ).to eq(
      "---\ntitle: A second title\ndate: '2011-07-25'\ntags:\n- some_tag\n- another tag\n- tag\n---\n\n**Foo**\n"
    )
  end

  it "ignores iframe and comment tags when converting to markdown" do
    post = WP2Middleman::MiddlemanPost.new post_with_iframe, body_to_markdown: true

    expect(post.file_content).to eq("---\ntitle: A fourth item with iframe and comment\ndate: '2011-07-26'\ntags:\n- some_tag\n- another tag\n- tag\npublished: false\n---\n\nHere's a post with an iframe and a comment.\n\n\n<!--more-->\n\n\n<iframe width=\"400\" height=\"100\" style=\"position: relative; display: block; width: 400px; height: 100px;\" src=\"http://bandcamp.com/EmbeddedPlayer/v=2/track=833121761/size=venti/bgcol=FFFFFF/linkcol=4285BB/\" allowtransparency=\"true\" frameborder=\"0\"><a href=\"http://dihannmoore.bandcamp.com/track/you-do-it-for-me\">\"YOU DO IT FOR ME\" by DIHANN MOORE</a></iframe>\n")
  end

  it "appends included fields in with frontmatter" do
    expect(post_two).to receive(:field).with('wp:post_id').and_return('209')
    post = WP2Middleman::MiddlemanPost.new post_two, include_fields: ['wp:post_id']

    expect( post.file_content ).to eq(
      "---\ntitle: A second title\ndate: '2011-07-25'\ntags:\n- some_tag\n- another tag\n- tag\nwp:post_id: '209'\n---\n\n <strong>Foo</strong>\n"
    )
  end

  it "reports 'published: false' in the post's frontmatter when post is not published" do
    post = WP2Middleman::MiddlemanPost.new post_three

    expect( post.file_content ).to eq(
      "---\ntitle: 'A third title: With colon'\ndate: '2011-07-26'\ntags:\n- some_tag\n- another tag\n- tag\npublished: false\n---\n\nFoo\n"
    )
  end

  it "does no formatting by default" do
    post = WP2Middleman::MiddlemanPost.new post_two

    expect( post.formatted_post_content ).to eq(" <strong>Foo</strong>")
  end

  it "does markdown formatting" do
    post = WP2Middleman::MiddlemanPost.new post_two, body_to_markdown: true

    expect( post.formatted_post_content ).to eq("**Foo**")
  end
end
