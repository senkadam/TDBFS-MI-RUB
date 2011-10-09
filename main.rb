# To change this template, choose Tools | Templates
# and open the template in the editor.

class Node
  attr_accessor :number,:state 
  def initialize(number)
    @number=number.to_i
    @neighbours=Array.[]
    #0 fresh, 1 open, 2 closed
    @state=0
  end
  
  def add_neighbour(neighbour)
    @neighbours.push(neighbour)
  end
  
  def get_first_neighbour
    @neighbours.delete(@neighbours.first)
  end
  
  def to_s
    string=@number.to_s+":"
    i=0
    @neighbours.each do
      string=string+" "+@neighbours[i].to_s
      i=i+1
    end
    string+" State: "+@state.to_s
  end
  
  def clone
    node=Node.new(self.number)
    @neighbours.each do |non_node|
      node.add_neighbour(non_node.dup)
    end
    node
  end
  
end

class Graph
  attr_accessor :non
  def initialize
    @non=Array.[]
  end
  
  def push_node(node)
    @non.push(node)
  end
  
  def get_node(non)
    @non[non-1]
  end
  
  def clone
    graph=Graph.new
    @non.each do |non_node|
      graph.push_node(non_node.clone)
    end
    graph
  end
  
  
end

class DFS
  attr_reader :string 
  def initialize(graph)
    @graph=graph
    @string=""
    
  end
  
  def output(node)
    if(@string=="")
      @string=@string+node.number.to_s
    else
      @string=@string+" "+node.number.to_s
    end
    
    
    #p @string
    @string
  end
  
  def search(node)
    # p "Node "+node.to_s  
    node.state=(1)
    # p "Node "+node.to_s  
    output(node)
    while (fn=node.get_first_neighbour)!=nil
      node_sea=@graph.get_node(fn.to_i)
      if node_sea.state==0 
        #p node_sea.to_s
        search(node_sea)
      end
    end     
    node.state=(2)      
  end
    
end

class BFS
  attr_reader :string 
  def initialize(graph)
    @graph=graph
    @string=""
  end
  
  def output(node)
    if(@string=="")
      @string=@string+node.number.to_s
    else
      @string=@string+" "+node.number.to_s
    end
    
    
    #p @string
    @string
  end
  
  def search(node)
    queue=Array.[]
    queue.push(node)
    output(node)
    while !queue.empty?
      node=queue.delete(queue.first)
      while (fn=node.get_first_neighbour)!=nil
        node_fn=@graph.get_node(fn.to_i)
        if node_fn.state==0
          output(node_fn)
          node_fn.state=(1)
          queue.push(node_fn)
        end
      end
      node.state=(2)
      
    end
  end
    
end



number_of_graphs=gets.to_i
#p "NOG"+number_of_graphs.to_s
number_of_nodes=gets.to_i
#cyklus pro grafy - postupne nacitani grafu
g=0
while number_of_graphs>0
  #p "NON"+number_of_nodes.to_s
  graph=Graph.new
  g=g+1
  #nacitani jednotlivejch uzlu a jejich sousedu
  while number_of_nodes>0
    # p "novy nody"
    line=gets;
    line.delete "\n"
    numbers= line.scan(/\w+/)
    i=0
    node=Node.new(numbers[0].to_i)
    #non number of nodes
    non=numbers[1].to_i
    i=2
    while  i < non+2
      node.add_neighbour(numbers[i])
      i=i+1
    end
    graph.push_node(node)
       #p "node "+node.to_s
    
    number_of_nodes=number_of_nodes-1
  end
  line=gets.delete "\n"
  orders=line.scan(/\w+/)
  p "graph "+g.to_s
  while orders.length == 2
    if(orders[1].to_i==0 && orders[0].to_i!=0 )
      graphcloned=graph.clone
      dfs=DFS.new(graphcloned)
      dfs.search(graphcloned.get_node(orders[0].to_i))
      p dfs.string
    end
    
    if(orders[1].to_i==1 && orders[0].to_i!=0 )
      graphcloned=graph.clone
      bfs=BFS.new(graphcloned)
      bfs.search(graphcloned.get_node(orders[0].to_i))
      p bfs.string
    end
    
    #    p "orderA "+orders[0]
    #    p "orderB "+orders[1]
    line=gets.delete "\n"
    orders=line.scan(/\w+/)
  end
  number_of_nodes=orders[0].to_i
  number_of_graphs=number_of_graphs-1
end

