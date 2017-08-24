# Introduction

This plugin adds a `{% codepen %}` Liquid tag to Jekyll (and Octopress) that generates a [CodePen](http://codepen.io) embed code.

# Installation

Move `codepen.rb` into the `_plugins` folder at the root of your Jekyll project.

# Syntax

```liquid
{% codepen slug-hash [data-attr:value]... %}
```

## Options

All [CodePen embed attributes](https://blog.codepen.io/documentation/features/embedded-pens/) are configurable with this extension.

Parameter         | Default      | Notes                         
------------------|--------------|-------------------------------
theme-id          | 0            | Sets theme                    
slug-hash         | none         | Required                      
user              | none         | Not required                  
default-tab       | result       | html/css/js/result            
height            | 300          | Not a part of themes          
show-tab-bar      | true         | true/false, **PRO only**      
animations        | run          | run/stop-after-5              
border            | none         | none/thin/thick               
border-color      | #000000      | Hex Color Code                
tab-bar-color     | #3d3d3e      | Hex Color Code                
tab-link-color    | #76daff      | Hex Color Code                
active-tab-color  | #cccccc      | Hex Color Code                
active-link-color | #000000      | Hex Color Code                
link-logo-color   | #ffffff      | Hex Color Code                
class             | none         | Class added to embedded iframe
custom-css-url    | none         | Style embed with custom CSS   
preview           | false        | Displays static preview       
rerun-position    | bottom right | top/left/right/bottom/hidden  

**Note:** All parameters, except `slug-hash` (the first parameter) are optional. All default values are assigned by CodePen, not this plugin.

## Examples

```liquid
{% codepen xwder %}
<p data-embed-version="2" data-slug-hash="xwder" class="codepen"></p>
```

```liquid
{% codepen xwder height:600 default-tab:css preview:true %}
<p data-embed-version="2" data-height="600" data-default-tab="css" data-preview="true" data-slug-hash="xwder" class="codepen"></p>
```

## Global Configuration

Options may also be set globally by defining a `codepen` entry in the `_config.yml` file.

```
codepen:
  theme-id: dark
  show-tab-bar: false
  rerun-position: hidden
```

**Note:** Inline options overwrite the global options.

## Template

This extension allows you to define a template located at `_includes/codepen.html`, exposing `pen_url`, `user`, `title`, `author_name` and `data_attributes` variables, to override the default output.

```liquid
<p class="codepen" {{ data_attributes }}>
  See the Pen <a href="{{ pen_url }}">{{ title }}</a>
  by {{ author_name }} (<a href="//codepen.io/{{ user }}">{{ user }}</a>).
</p>
```

**Note:** The sample template above does not include the CodePen script. You may include the CodePen script automatically on pages which contain the CodePen widget using the follow snippet:

```liquid
{% if page.content contains '<p class="codepen"' %}
<!-- CodePen -->
<script async src="//assets.codepen.io/assets/embed/ei.js"></script>
{% endif %}
```
