package 'xvfb'
package 'xfonts-75dpi'

# download wkhtmltopdf
remote_file "/home/#{node['user']['name']}/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb" do
  source "http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb"
  mode 0644
  action :create_if_missing
end

# install wkthmltopdf
bash 'install wkhtmltopdf' do
  cwd "/home/#{node['user']['name']}"
  code <<-EOH
    sudo dpkg -i wkhtmltox-0.12.2.1_linux-trusty-amd64.deb
    sudo apt-get -f install
    sudo dpkg -i wkhtmltox-0.12.2.1_linux-trusty-amd64.deb
  EOH
  not_if { File.exists?("/usr/local/bin/wkhtmltopdf.sh") }
end

# configure xvfb
bash 'configure xvfb' do
  cwd "/usr/local/bin"
  code <<-EOH
    echo 'exec xvfb-run -a -s "-screen 0 640x480x16" wkhtmltopdf "$@"' | sudo tee /usr/local/bin/wkhtmltopdf.sh >/dev/null
    chmod a+x /usr/local/bin/wkhtmltopdf.sh
    ln -s /usr/local/bin/wkhtmltopdf.sh /usr/local/bin/wkhtmltopdf
  EOH
  not_if { File.exists?("/usr/local/bin/wkhtmltopdf") }
end