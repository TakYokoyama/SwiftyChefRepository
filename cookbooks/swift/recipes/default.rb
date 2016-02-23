#
# Cookbook Name:: swift
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
execute "apt-get-update" do
  command "apt-get update"
end

libraries = ["clang", "libicu-dev"]
libraries.each do |lib|
  package lib do
    action :install
  end
end

swift_snapshot = "swift-2.2-SNAPSHOT-2016-02-08-a-ubuntu15.10"
filenames = [
  "#{swift_snapshot}.tar.gz",
  "#{swift_snapshot}.tar.gz.sig"
]

filenames.each do |filename|
  cookbook_file filename do
    source filename
    path "/usr/local/src/#{filename}"
  end
end

bash "setup" do
  code <<-EOH
    wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import -
    gpg --keyserver hkp://pool.sks-keyservers.net --refresh-keys Swift
    gpg --verify /usr/local/src/#{swift_snapshot}.tar.gz
    tar xzf /usr/local/src/#{swift_snapshot}.tar.gz -C /usr/local/src
    echo 'PATH=$PATH:/usr/local/src/#{swift_snapshot}/usr/bin' >> ~/.profile
  EOH
end
