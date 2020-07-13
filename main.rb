class Node

  # [x] Build a Node class. It should have attributes for the data it stores
    # as well as its left and right children.
  # [x] As a bonus, try including the Comparable module
    # and make nodes compare using their data attribute.

  include Comparable

  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end

  def <=>(other)
    value <=> other.value
  end

end

class Tree

  # [x] Build a Tree class which accepts an array when initialized. The Tree class should have a
    # root attribute which uses the return value of #build_tree which you’ll write next.

  attr_reader :ary, :root

  def initialize(ary)
    @ary = ary
    @root = build_tree(ary)
  end

  # [x] #build_tree method which takes an array of data
    # (e.g. [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]) and turns it into a balanced
    # binary tree full of Node objects appropriately placed (don’t forget to sort and remove
    # duplicates!). The #build_tree method should return the level-1 root node.

  # from my merge sort project
  def merge(left, right)
    merged = []
    until left.empty? || right.empty?
      merged << (left.first <= right.first ? left : right).shift
    end
    merged + (right.empty? ? left : right)
  end

  # from my merge sort project
  def merge_sort(ary)
    return ary if ary.length == 1
    return merge(merge_sort(ary[0..ary.length / 2 - 1]), merge_sort(ary[ary.length / 2..-1]))
  end

  # adapted from https://www.youtube.com/watch?v=VCTP81Ij-EM&feature=youtu.be
  def tree_from_array(ary, start, finish)
    return nil if start > finish
    midpoint = (start + finish) / 2
    root = Node.new(ary[midpoint])
    root.left = tree_from_array(ary, start, midpoint - 1)
    root.right = tree_from_array(ary, midpoint + 1, finish)
    return root
  end

  def build_tree(ary)
    ary.uniq!
    ary = merge_sort(ary)
    tree_from_array(ary, 0, ary.length - 1)
  end

  # [x] #insert and #delete method which accepts a value to insert/delete
  # adapted from https://www.geeksforgeeks.org/binary-search-tree-set-1-search-and-insertion/?ref=lbp
  def insert(root, node)
    if root.nil?
      root = node
    else
      if root < node
        root.right.nil? ? root.right = node : insert(root.right, node)
      else
        root.left.nil? ? root.left = node : insert(root.left, node)
      end
    end
  end

  def new_node_from_value(value)
    node = Node.new(value)
    insert(@root, node)
  end

  # adapted from https://www.geeksforgeeks.org/binary-search-tree-set-2-delete/?ref=lbp
  def min_value_node(node)
    current = node
    while !current.left.nil?
      current = current.left
    end
    return current
  end

  # adapted from https://www.geeksforgeeks.org/binary-search-tree-set-2-delete/?ref=lbp
  def delete(root, value)
    return root if root.nil?
    if value < root.value
      root.left = delete(root.left, value)
    elsif value > root.value
      root.right = delete(root.right, value)
    else
      if root.left.nil?
        temp = root.right
        root = nil
        return temp
      elsif root.right.nil?
        temp = root.left
        root = nil
        return temp
      end
      temp = min_value_node(root.right)
      root.value = temp.value
      root.right = delete(root.right , temp.value)
    end
    return root
  end

  def remove_node_at_value(value)
    delete(@root, value)
  end

  # [x] #find method which accepts a value and returns the node with the given value.
  # adapted from https://www.geeksforgeeks.org/binary-search-tree-set-1-search-and-insertion/?ref=lbp
  def find(root, value)
    return root if root.nil? || root.value == value
    return find(root.right, value) if root.value < value
    return find(root.left, value)
  end

  # [] #level_order method that returns an array of values.
    # This method should traverse the tree in breadth-first level order.
    # This method can be implemented using either iteration or recursion (try implementing both!).
    # Tip: You will want to use an array acting as a queue to keep track of all the child nodes
    # that you have yet to traverse and to add new ones to the list (as you saw in the video).

  # [] #inorder, #preorder, and #postorder methods that returns an array of values. Each method
     # should traverse the tree in their respective depth-first order.

  # [] #depth method which accepts a node and returns the depth(number of levels) beneath the node.

  # [] #balanced? method which checks if the tree is balanced.
    # A balanced tree is one where the difference between heights of left subtree and right subtree
    # of every node is not more than 1.

  # [] #rebalance method which rebalances an unbalanced tree.
    # Tip: You’ll want to create a level-order array of the tree before passing the array back
    # into the #build_tree method.

=begin
  Write a simple driver script that does the following:

  [] 1. Create a binary search tree from an array of random numbers
        (`Array.new(15) { rand(1..100) }`)
  [] 2. Confirm that the tree is balanced by calling `#balanced?`
  [] 3. Print out all elements in level, pre, post, and in order
  [] 4. try to unbalance the tree by adding several numbers > 100
  [] 5. Confirm that the tree is unbalanced by calling `#balanced?`
  [] 6. Balance the tree by calling `#rebalance`
  [] 7. Confirm that the tree is balanced by calling `#balanced?`
  [] 8. Print out all elements in level, pre, post, and in order
=end

# from the TOP assignment
def pretty_print(node = root, prefix="", is_left = true)
  pretty_print(node.right, "#{prefix}#{is_left ? "│ " : " "}", false) if node.right
  puts "#{prefix}#{is_left ? "└── " : "┌── "}#{node.value.to_s}"
  pretty_print(node.left, "#{prefix}#{is_left ? " " : "│ "}", true) if node.left
end

end

tree = Tree.new(([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]))
p tree.root
p tree.ary
tree.pretty_print
tree.new_node_from_value(10)
tree.pretty_print
tree.remove_node_at_value(23)
tree.pretty_print
tree.remove_node_at_value(10)
tree.pretty_print
tree.remove_node_at_value(5)
tree.pretty_print
tree.remove_node_at_value(67)
tree.pretty_print
tree.remove_node_at_value(150)
tree.pretty_print
p tree.find(tree.root, 23)
