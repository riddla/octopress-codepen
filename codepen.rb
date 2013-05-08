# Title: CodePen plugin for Jekyll/Octopress
# Author: Volker Rose (@riddla | http://volker-rose.de/ | volker.rose@gmail.com)
# Info: http://volker-rose.de/blog/2012/11/03/octopress-codepen-plugin/
# Credits: "Heavily inspired" (e.g. shamelessly copied) from the jsFiddle tag/plugin for Jekyll by Brian Arnold (@brianarn)
# Description: Given a CodePen shortcode, outputs the CodePen embed code e.g. the iframe.
#
# Syntax: {% codepen href user [type] [height] %}
#
# Examples:
#
# Input: {% codepen vhfon riddla %}
# Output: <pre class="codepen" data-height="300" data-type="result" data-href="vhfon" data-user="riddla"><code></code></pre>
#         <script async src="http://codepen.io:/assets/embed/ei.js"></script>
#
# Input: {% codepen vhfon riddla css 600 %}
# Output: <pre class="codepen" data-height="600" data-type="css" data-href="vhfon" data-user="riddla"><code></code></pre>
#         <script async src="http://codepen.io:/assets/embed/ei.js"></script>

module Jekyll
  class CodePen < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      if /(?<pen>\w+)(?:\s(?<user>\w+))(?:\s(?<type>\w+))?(?:\s(?<height>\d+))?/ =~ markup
        @pen    = pen
        @user   = user
        @type   = type || 'result'
        @height = height || '300'
      end
    end

    def render(context)
      if @pen && @user
        "<pre class=\"codepen\" data-height=\"#{@height}\" data-type=\"#{@type}\" data-href=\"#{@pen}\" data-user=\"#{@user}\"><code> </code></pre>\n<script async src=\"http://codepen.io:/assets/embed/ei.js\"></script>"
      else
        "Error processing input, expected syntax: {% codepen href user [type] [height] %}"
      end
    end
  end
end

Liquid::Template.register_tag('codepen', Jekyll::CodePen)
