#
# Cookbook Name:: couchbase
# Recipe:: test_xdcr_create
#
# Copyright 2015, Gannett
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# 'Software'), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

couchbase_manage_xdcr 'test' do
  username node['couchbase']['server']['username']
  password node['couchbase']['server']['password']
  replica_ip node['couchbase']['xdcr']['replica_ip']
  master_ip node['couchbase']['xdcr']['master_ip']
  replica_username node['couchbase']['server']['username']
  replica_password node['couchbase']['server']['password']
end

couchbase_manage_xdcr 'test' do
  username node['couchbase']['server']['username']
  password node['couchbase']['server']['password']
  master_ip node['couchbase']['xdcr']['master_ip']
  from_bucket node['couchbase']['xdcr']['from_bucket']
  to_bucket node['couchbase']['xdcr']['to_bucket']
  action :replicate
end
