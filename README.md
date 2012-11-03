# Introduction

This plugin adds a `{% codepen %}` tag to Jekyll/Octopress. It (surprisingly) embeds [CodePen](http://codepen.io)s. You can find an [example over at my personal blog](http://volker-rose.de/blog/2012/11/03/codepen-plugin-for-octopress/).

# Installation

Move `codepen.rb` into the `plugins` folder at the root of your octopress repo.

# Syntax #

	{% codepen href user [type] [height] %}

# Usage

    {% codepen vhfon riddla %}

Option parameters, such as `{% codepen vhfon riddla css 400 %}` can be used.

## Allowed options

 * `type` - type of embed; defaults to `result`; other types are `css` and `js`
 * `height` - the height of the embedded iframe

# Credits

This plugin was heavily inspired (e.g. shamelessly copied) from [Brian Arnolds jsFiddle Octopress plugin](http://brianarn.github.com/blog/2011/08/jsfiddle-plugin/).