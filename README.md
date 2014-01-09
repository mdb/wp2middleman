[![Build Status](https://travis-ci.org/mdb/wp2middleman.png?branch=master)](https://travis-ci.org/mdb/wp2middleman)

# wp2middleman

Migrate the posts contained in a Wordpress XML export file to Middleman-style markdown files.

## Installation

```
git clone http://github.com/mdb/wp2middleman
cd wp2middleman
gem build wp2middleman.gemspec
```
Make a note of the version of the gem in the command line output, and insert it in the place of `VERSION` in the following command:

```
gem install wp2middleman-VERSION.gem
```
For example, if the version is `0.0.1`, you would run this:
```
gem install wp2middleman-0.0.1.gem
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

### Optional parameters

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
