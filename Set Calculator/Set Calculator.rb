class SetCalculator
  # initialize variables and define their accessors
  attr_accessor :set_x, :set_y, :set_z
  def initialize
    # initially all sets are empty
    @set_x = BST.new
    @set_y = BST.new
    @set_z = BST.new
  end

  # function to set the values for the three sets x, y, z
  # arg = set to be initialized with values
  # value = array of values to be inserted into the set
  def set_values (arg,value)
    case arg
    when 'X'
      #reset X and load values one by one
      @set_x = BST.new
      for i in value
          @set_x.insert(i.to_i)
      end
    when 'Y'
      #reset Y and load values one by one
      @set_y = BST.new
      for i in value
          @set_y.insert(i.to_i)
      end
    when 'Z'
      #reset Z and load values one by one
      @set_z = BST.new
      for i in value
        unless i == 'Z'
          @set_z.insert(i.to_i)
        end
      end
    else
      nil
    end
  end
end

# node class defining properties of each node
# value = value of node
# left = left child node
# right = right child node
class TreeNode
  attr_accessor :value, :left, :right
  def initialize (value)
    @value = value
    @left = nil
    @right  = nil
  end
end

# Binary search tree class defining functions for the BST sets
class BST
  # getter setter initialization for root node, initially root node is nil
  attr_accessor :root
  def initialize
    @root = nil
  end

  # insert functionality for BST, traversing the tree and inserting value, skips duplicates
  def insert(value, node = @root)
    # initialize root node if its nil
    if @root == nil
      @root = TreeNode.new(value)
    # if value to be inserted is less than the node, go left
    elsif node.value> value
      # if immediate node is free, add value
      if node.left == nil
        node.left = TreeNode.new(value)
      # if not, check more nodes in left
      else
        insert(value,node.left)
      end
      # if value to be inserted is more than the node, go right
    elsif node.value< value
      # if immediate node is free, add value
      if node.right == nil
        node.right = TreeNode.new(value)
        # if not, check more nodes in right
      else
        insert(value,node.right)
      end
    end
  end

  # in order traversal for printing the sets
  def print_in_order(node = self.root)
    if node!=nil
      print_in_order(node.left)
      print"#{node.value} "
      print_in_order(node.right)
    end
  end

  # traversing one bst to add all elements to another bst for implementing union
  # since duplicate elements dont get added the bst is maintained
  def union(head2)
    if head2 != nil
      union(head2.left)
      self.insert(head2.value)
      union(head2.right)
    end
  end

  # traversing bst to find if a value exists
  def find(value, node = self.root)
    if node !=nil
      find(value,node.left)
      if node.value == value
        return true
      end
      find(value, node.right)
    end
  end

  # using find functionality to find which values of one bst exist in another to get intersection
  def intersection(head,inBST)
    if head !=nil
      intersection(head.left,inBST)
      if  self.find(head.value)
        inBST.insert(head.value)
      end
      intersection(head.right,inBST)
    end
    inBST
  end

  # traversing bst to go through all nodes and getting values using lambda expression provided
  def evaluate_lambda(head = self.root,str)
    if head != nil
      evaluate_lambda(head.left,str)
      block = eval(str)
      puts block.call(head.value)
      evaluate_lambda(head.right,str)
    end
  end

  # using marshaling and unmarshalling to implement deep copy
  def clone
    bst = Marshal.dump(self)
    Marshal.load(bst)
  end
end


# implementation

# initialize variables
sc = SetCalculator.new
command = []

# implement command loop that exists when command is "q"
while command[0] != "q"
  puts "\nPlease enter command with arguments:
X values : Reset X set with provided values
Y values : Reset Y set with provided values
Z values : Reset Y set with provided values
a i : Add i to X set
r : Y = X, Z = Y, X = Z Contents of set rotated
s : Contents of X and Y are switched
u : Union of sets X and Y. Result set stored in X.
i : Intersection of sets X and Y. Result set stored in X.
c : X deep copied to Y.
l aString : Lambda expression in the String applied to set X.
q : quit the program.
"
  # get user input and modify as required
  user_input = gets.chomp
  command = user_input.split(/[, ]/)
  values = command.slice(1,command.size)

  # use case wise code for command execution
  case command[0].upcase

  # Reset X set with provided values
  when "X"
    sc.set_values('X',values)

  # Reset Y set with provided values
  when "Y"
    sc.set_values('Y',values)

  # Reset Z set with provided values
  when "Z"
    sc.set_values('Z',values)

  # Add i to X set
  when "A"
    sc.set_x.insert(values[0].to_i)

  # Y = X, Z = Y, X = Z Contents of set rotated
  when "R"
    sc.set_x,sc.set_y,sc.set_z = sc.set_y,sc.set_z,sc.set_x

  # Contents of X and Y are switched
  when "S"
    sc.set_x,sc.set_y = sc.set_y,sc.set_x\

  # Union of sets X and Y. Result set stored in X.
  when "U"
    sc.set_x.union(sc.set_y.root)

  # Intersection of sets X and Y. Result set stored in X.
  when "I"
    sc.set_x = sc.set_x.intersection(sc.set_y.root,BST.new)

  # X deep copied to Y.
  when "C"
    sc.set_y = sc.set_x.clone

  # Lambda expression in the String applied to set X.
  when "L"
    sc.set_x.evaluate_lambda(user_input[2..])

  # Quit the program.
  when "Q"
    break
  else
    puts "Please check your entry"
  end

  # print all sets at the end of each cycle
  puts "X = "
  sc.set_x.print_in_order
  puts "\nY = "
  sc.set_y.print_in_order
  puts "\nZ = "
  sc.set_z.print_in_order
end

