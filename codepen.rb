# Title: CodePen plugin for Jekyll
# Description: Liquid tag to generate a CodePen embed.
# Authors:
#  - Volker Rose (@riddla | http://volker-rose.de/ | volker.rose@gmail.com)
#  - Aaron Gustafson (@aarongustafson | https://www.aaron-gustafson.com)
#  - Joey Hoer (@joeyhoer | https://joeyhoer.com)
#
# Link: https://blog.codepen.io/documentation/features/embedded-pens/
#
# Note: You must include the CodePen script elsewhere on your page:
#   <script async src="//assets.codepen.io/assets/embed/ei.js"></script>
#
# Syntax: {% codepen slug-hash [data-attr:value]... %}
#
# Example:
#   {% codepen xwder %}
#   <p data-embed-version="2" data-slug-hash="xwder" class="codepen"></p>
#
# Example:
#   {% codepen xwder height:600 default-tab:css preview:true %}
#   <p data-embed-version="2" data-height="600" data-default-tab="css"
#   data-preview="true" data-slug-hash="xwder" class="codepen"></p>
#

if ( ! defined? CODEPEN_CACHE_DIRECTORY )
  CODEPEN_CACHE_DIRECTORY = File.expand_path('../../_cache', __FILE__)
  FileUtils.mkdir_p(CODEPEN_CACHE_DIRECTORY)
end

module Jekyll
  class CodePen < Liquid::Tag

    ## Constants

    @@ATTRIBUTES = %w(
      height
      active-link-color
      active-tab-color
      animations
      border
      border-color
      class
      custom-css-url
      default-tab
      embed-version
      link-logo-color
      preview
      rerun-position
      show-tab-bar
      slug-hash
      tab-bar-color
      tab-link-color
      theme-id
    )

    @@DEFAULTS = {
      'embed-version' => '2'
    }

    def self.DEFAULTS
      return @@DEFAULTS
    end

    # Load metadata from cache
    Cache_file = File.join(CODEPEN_CACHE_DIRECTORY, "codepen.yml")
    if File.exists?(Cache_file)
      Cache = open(Cache_file) { |f| YAML.load(f) }
    else
      Cache = Hash.new
    end

    def initialize(tag_name, markup, tokens)
      super

      @config = {}
      # Set defaults
      override_config(@@DEFAULTS)

      # Override configuration with values defined within _config.yml
      if Jekyll.configuration({}).has_key?('codepen')
        config = Jekyll.configuration({})['codepen']
        override_config(config)
      end

      params = markup.split

      # First argument (required) is slug_hash
      @slug_hash = params.shift.strip
      override_config({'slug-hash' => @slug_hash})

      if params.size > 0
        # Override configuration with parameters defined within Liquid tag
        config = {} # Reset local config
        params.each do |param|
          param = param.gsub /\s+/, '' # Remove whitespaces
          key, value = param.split(':',2) # Split first occurrence of ':' only
          config[key.to_sym] = value
        end
        override_config(config)
      end
    end

    def override_config(config)
      config.each{ |key,value| @config[key] = value }
    end

    def render(context)
      content = super

      if @slug_hash
        cache_key = "#{@slug_hash}"

        # Use cached metadata, if available
        if Cache.has_key? cache_key
          # puts "CodePen Embed: Using Cached Pen #{@id}"
          user        = Cache[cache_key]['user']
          title       = Cache[cache_key]['title']
          author_name = Cache[cache_key]['author_name']
        end

        # Build new embed
        # Note: /#{@user}/ is optional
        pen_url = "//codepen.io/pen/#{@slug_hash}"

        # Extract pen information
        if ! user || ! title || ! author_name
          uri = URI.parse("https://codepen.io/api/oembed?url=#{pen_url}")
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          request = Net::HTTP::Get.new(uri.request_uri)
          response = http.request(request)
          data = response.body
          result = JSON.parse(data)
          if ! result['success']
            puts "CodePen Embed: Pen #{@id} not found"
          end

          # Set metadata
          author_url = result['author_url']
          author_uri = URI.parse(author_url)
          user = author_uri.path.split('/').drop(1).first
          title = result['title']
          author_name = result['author_name']

          # Store metadata in cache
          metadata = {
            'user'        => user,
            'title'       => title,
            'author_name' => author_name
          }
          Cache[cache_key] = metadata
          File.open(Cache_file, 'w') { |f| YAML.dump(Cache, f) }
        end

        template_path = File.join(Dir.pwd, "_includes", "codepen.html")
        if File.exist?(template_path)
          site = context.registers[:site]

          partial = File.read(template_path)
          template = Liquid::Template.parse(partial)

          template.render!(({
            "pen_url" => pen_url,
            "user" => user,
            "title" => title,
            "author_name" => author_name,
            "data_attributes" => render_data_attributes()}).merge(site.site_payload))
        else
          # Build embed
          <<~HTML
          <p class="codepen" #{render_data_attributes()}>
            See the Pen <a href=\"#{pen_url}\">#{title}</a>
            by #{author_name} (<a href=\"//codepen.io/#{user}\">#{user}</a>)
            on <a href=\"//codepen.io\">CodePen</a>.
          </p>
          <script async src=\"https://production-assets.codepen.io/assets/embed/ei.js\"></script>
          HTML
        end
      else
        puts "CodePen Embed: Error processing input, expected syntax {% codepen slug [data-attr:value]... %}"
      end
    end

    def render_data_attributes
      result = ''
      @config.each do |key,value|
        if @@ATTRIBUTES.include?(key.to_s)
          result << " data-#{key}=\"#{value}\""
        end
      end
      return result
    end

  end
end

Liquid::Template.register_tag('codepen', Jekyll::CodePen)
