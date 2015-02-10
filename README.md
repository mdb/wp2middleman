[![Build Status](https://travis-ci.org/mdb/wp2middleman.png?branch=master)](https://travis-ci.org/mdb/wp2middleman)
[![Code Climate](https://codeclimate.com/github/mdb/wp2middleman/badges/gpa.svg)](https://codeclimate.com/github/mdb/wp2middleman)

# wp2middleman

A command line tool to help move a Wordpress blog to [Middleman](http://middlemanapp.com).

wp2middleman migrates the posts contained in a Wordpress XML export file to Middleman-style markdown files.

## Installation

```
gem install wp2middleman
```

## Commandline Usage

```
wp2mm some_wordpress_export.xml
```

Results in YYYY-MM-DD-Some-Title.html.markdown, formatted as such:

```
---
title: 'Some Title'
date: YYYY-MM-DD
tags: foo, bar
---

<p>The post content in HTML or text, depending on how it was saved to Wordpress.</p>
<ul>
<li>list item</li>
<li>another list item</li>
</ul>
```

## Optional Parameters

```
--body_to_markdown                         converts to markdown
--include_fields=FIELD_ONE FIELD_TWO ETC   includes specific fields in frontmatter
```

### Convert to Markdown

```
wp2mm some_wordpress_export.xml --body_to_markdown true
```

Results in YYYY-MM-DD-Some-Title.html.markdown, formatted as such:

```
---
title: 'Some Title'
date: YYYY-MM-DD
tags: foo, bar
---

The post content in markdown or text, depending on how it was saved to Wordpress.

* list item
* another list item
```

### Include specific post fields

```
wp2mm some_wordpress_export.xml --include_fields wp:post_id link
```

Pulls the specified key/values out of the post xml and includes it in frontmatter:

```
---
title: 'Some Title'
date: YYYY-MM-DD
tags: foo, bar
wp:post_id: '280'
link: http://somewebsite.com/2012/10/some-title
---

<p>The post content in HTML or text, depending on how it was saved to Wordpress.</p>
<ul>
<li>list item</li>
<li>another list item</li>
</ul>
```

