package "nginx"

# remove default nginx config
default_path = "/etc/nginx/sites-enabled/default"
execute "rm -f #{default_path}" do
  only_if { File.exists?(default_path) }
end

# start nginx
service "nginx" do
  supports [:status, :restart]
  action :start
end

# set custom nginx config
template "/etc/nginx/sites-enabled/#{node['app']}" do
  source "nginx.conf.erb"
  mode 0644
  owner node['user']['name']
  group node['group']
  notifies :restart, "service[nginx]", :delayed
end

# load ssl certificates
ca_path = "/home/#{node['user']['name']}/rapidssl_bundle.crt"
cookbook_file ca_path do
  source "rapidssl_bundle.crt"
  mode 0644
  owner node['user']['name']
  group node['group']
end

crt_path = "/home/#{node['user']['name']}/#{node['ssl']['cert']}.crt"
cookbook_file crt_path do
  source "#{node['ssl']['cert']}.crt"
  mode 0644
  owner node['user']['name']
  group node['group']
end

key_path = "/home/#{node['user']['name']}/#{node['ssl']['cert']}.key"
cookbook_file key_path do
  source "#{node['ssl']['cert']}.key"
  mode 0644
  owner node['user']['name']
  group node['group']
end

chain_path = "/home/#{node['user']['name']}/#{node['ssl']['cert']}.chained.crt"
execute "cat #{crt_path} #{ca_path} > #{chain_path}"
execute "mv #{chain_path} /etc/ssl && chmod 400 /etc/ssl/#{node['ssl']['cert']}.chained.crt"
execute "mv #{key_path} /etc/ssl && chmod 400 /etc/ssl/#{node['ssl']['cert']}.key"