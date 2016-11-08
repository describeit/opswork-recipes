%w(
  common
  rbenv
  nodejs
  wkhtmltopdf
  redis
  app
  nginx
).each do |r|
  include_recipe "describeit::#{r}"
end
