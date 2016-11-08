#
# Cookbook Name:: describeit
# Recipe:: default
#
# Copyright 2015, Describeit, Inc
#
# All rights reserved - Do Not Redistribute
#
# update package database
execute "apt-get update"

# install default packages
%w(
  autoconf
  bison
  build-essential
  curl
  git-core
  libffi-dev
  libgdbm-dev
  libgdbm3
  libncurses5-dev
  libpq-dev
  libreadline-dev
  libreadline6-dev
  libsqlite3-dev
  libssl-dev
  libxml2-dev
  libxslt1-dev
  libyaml-dev
  postfix
  sqlite3
  telnet
  tree
  zlib1g-dev
).each do |p|
  package p
end

# install project packages
# note: gs-esp package replaced with ghostscript-x
#       https://github.com/raducotescu/CanonCAPTdriver/issues/1#issuecomment-14830287
%w(
  ghostscript
  ghostscript-x
  imagemagick
  libgs-dev
  libmysqlclient-dev
  monit
  mysql-client
  openssl
).each do |p|
  package p
end


# set timezone
bash "set timezone" do
  code <<-EOH
    echo 'US/Eastern' > /etc/timezone
    dpkg-reconfigure -f noninteractive tzdata
  EOH
  not_if "date | grep -q 'EDT\|EST'"
end