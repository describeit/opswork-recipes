%w(
  redis
  app
  nginx
).each do |r|
  include_recipe "describeit::#{r}"
end
