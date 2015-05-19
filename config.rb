###
# Blog settings
###

Time.zone = "Madrid"
I18n.default_locale = :es

activate :blog do |blog|
  blog.sources = "articles/{year}-{month}-{day}-{title}.html"
  blog.taglink = "tag/{tag}.html"
  blog.tag_template = "tag.html"
  blog.paginate = true
end

set :casper, {
  blog: {
    url: 'http://blog.gardenweb.es',
    name: 'Gardenweb',
    description: 'Tu blog sobre productos de jardinería y más..',
    date_format: '%d %B %Y',
    navigation: true,
    logo: nil # Optional
  },
  author: {
    name: 'Daniel',
    bio: 'Soy una persona apasionada por la fotografía, el diseño gráfico y el branding. 
          Me considero una persona muy adaptable y con la mente abierta a nuevas ideas. 
          Amante de las nuevas tecnologías con un futuro para seguir formando.', # Optional
    location: 'Elche', # Optional
    website: 'www.gardenweb.es', # Optional
    gravatar_email: 'danielsanabriaalbert@gmail.com' # Optional
  },
  navigation: {
    "Inicio" => "/"
  }
}

page '/feed.xml', layout: false
page '/sitemap.xml', layout: false

ignore '/partials/*'

ready do
  blog.tags.each do |tag, articles|
    proxy "/tag/#{tag.downcase.parameterize}/feed.xml", '/feed.xml', layout: false do
      @tagname = tag
      @articles = articles[0..5]
    end
  end

  proxy "/author/#{blog_author.name.parameterize}.html", '/author.html', ignore: true
end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

# Reload the browser automatically whenever files change
activate :livereload

activate :deploy do |deploy|
  deploy.method = :git
  deploy.branch = 'master'
  deploy.build_before = true
end

# Pretty URLs - http://middlemanapp.com/basics/pretty-urls/
activate :directory_indexes

# Middleman-Syntax - https://github.com/middleman/middleman-syntax
set :haml, { ugly: true }
set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true
activate :syntax, line_numbers: true


set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

set :partials_dir, 'partials'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :asset_hash
end
