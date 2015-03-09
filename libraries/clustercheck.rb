require 'net/http'
require 'json'

# rubocop:disable Metrics/MethodLength
def get_node_json(ipaddress, username, password)
  uri = URI("http://#{ipaddress}:8091/pools/default")
  check = Net::HTTP::Get.new(uri)
  check.basic_auth username, password
  begin
    res = Net::HTTP.start(uri.hostname, uri.port, :open_timeout => 10) { |http| http.request(check) }
    return unless res.code == "200"
    body = JSON.parse(res.body)
    return body
  rescue # => e
    return
  end
end
# rubocop:enable Metrics/MethodLength

def found_cluster(jvalue)
  if jvalue['nodes'].length > 1
    return true
  else
    return false
  end
end

def not_in_cluster(jvalue, selfipaddress)
  hostcheck = selfipaddress + ":8091"
  jvalue['nodes'].each do |ncheck|
    return false if ncheck['hostname'] == hostcheck
  end
  true
end

def get_known_nodes_from_json(jvalue)
  prefix = "ns_1@"
  separator = ","
  known_nodes = ""
  jvalue['nodes'].each do |known|
    known_nodes = known_nodes + separator + prefix + known['hostname'].sub(/:8091/, '')
  end
  known_nodes
end

def get_timestamp(jvalue)
  timestamp = ""
  jvalue['nodes'].each do |cnode|
    ts = Time.now.to_i
    timestamp = ts - cnode['uptime'].to_i
  end
  timestamp
end

def join_to_cluster(jvalue, selfipaddress, clusterip)
  return unless not_in_cluster(jvalue, selfipaddress)
  joinarray = {}
  clusternodes = get_known_nodes_from_json(jvalue)
  joinarray['knownnodes'] = "ns_1@#{selfipaddress}" + clusternodes
  joinarray['nodetojoin'] = clusterip
  joinarray
end

def node_to_join(searchhash, selfipaddress, username, password)
  joinhash = {}
  prefix = "ns_1@"
  separator = ","
  i = 0
  while i < 3
    breakloop = true
    unless searchhash.empty?
      searchhash.each do |node|
        info = get_node_json(node['ipaddress'], username, password)
        if info
          if found_cluster(info)
            joinarray = join_to_cluster(info, selfipaddress, node['ipaddress'])
            return joinarray 
          end
          if node['ipaddress'] != selfipaddress
            ip = node['ipaddress']
            joinhash[ip] = get_timestamp(info)
          end
        else
          breakloop = false
        end
      end
    end
    break if breakloop
    i +=     sleep 10
  end
  return if joinhash.empty?
  joinarray = {}
  pick = joinhash.sort.reverse.pop
  print "pick is #{pick}\n"
  joinarray['nodetojoin'] = pick[0]
  joinarray['knownnodes'] = prefix + selfipaddress + separator + prefix + joinarray['nodetojoin']
  # print "join array is #{joinarray}\n"
  joinarray
end

# target=node_to_join(cluster,selfipaddress,username,password)
# print "goning to join #{target}"
