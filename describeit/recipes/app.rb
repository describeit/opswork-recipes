# create shared directory structure for app
shared_path = "/home/#{node['user']['name']}/#{node['app']}/shared"
execute "mkdir -p #{shared_path}" do
  user node['user']['name']
  group node['group']
  creates shared_path
end

# create database.yml file
template "#{shared_path}/config/database.yml" do
  source "database.yml.erb"
  mode 0640
  owner node['user']['name']
  group node['group']
end

# create secrets.yml file
template "#{shared_path}/config/secrets.yml" do
  source "secrets.yml.erb"
  mode 0640
  owner node['user']['name']
  group node['group']
end

execute "mkdir -p #{shared_path}/log" do
  user node['user']['name']
  group node['group']
  command "mkdir -p #{shared_path}/log"
end

# # set puma config
# template "/etc/init.d/unicorn_#{node['app']}" do
#   source "unicorn.sh.erb"
#   mode 0755
#   owner node['user']['name']
#   group node['group']
# end

# # add init script link
# execute "update-rc.d unicorn_#{node['app']} defaults" do
#   not_if "ls /etc/rc2.d | grep unicorn_#{node['app']}"
# end