# [x] Build a Node class. It should have attributes for the data it stores
# as well as its left and right children.
# [x] As a bonus, try including the Comparable module
# and make nodes compare using their data attribute.
class Node
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

# [x] Build a Tree class which accepts an array when initialized. The Tree class should have a
# root attribute which uses the return value of #build_tree which you’ll write next.
class Tree
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

    merge(merge_sort(ary[0..ary.length / 2 - 1]), merge_sort(ary[ary.length / 2..-1]))
  end

  # adapted from https://www.youtube.com/watch?v=VCTP81Ij-EM&feature=youtu.be
  def build(ary, start, finish)
    return nil if start > finish

    midpoint = (start + finish) / 2
    root = Node.new(ary[midpoint])
    root.left = build(ary, start, midpoint - 1)
    root.right = build(ary, midpoint + 1, finish)
    root
  end

  def build_tree(ary)
    ary.uniq!
    ary = merge_sort(ary)
    build(ary, 0, ary.length - 1)
  end

  # [x] #insert and #delete method which accepts a value to insert/delete
  # adapted from https://www.geeksforgeeks.org/binary-search-tree-set-1-search-and-insertion/?ref=lbp
  def insert_node(node, root = @root)
    if root.nil?
      root = node
    elsif root < node
      root.right.nil? ? root.right = node : insert_node(node, root.right)
    else
      root.left.nil? ? root.left = node : insert_node(node, root.left)
    end
  end

  def insert(value)
    return if level_order.include? value

    node = Node.new(value)
    insert_node(node)
  end

  # adapted from https://www.geeksforgeeks.org/binary-search-tree-set-2-delete/?ref=lbp
  def min_value_node(node)
    current = node
    while !current.left.nil?
      current = current.left
    end
    current
  end

  # adapted from https://www.geeksforgeeks.org/binary-search-tree-set-2-delete/?ref=lbp
  def delete(value, root = @root)
    return root if root.nil?

    if value < root.value
      root.left = delete(value, root.left)
    elsif value > root.value
      root.right = delete(value, root.right)
    else
      if root.left.nil?
        temp = root.right
        root = nil
        return temp
      elsif root.right.nil?
        temp = root.left
        root = nil
        return temp
      else
        temp = min_value_node(root.right)
        root.value = temp.value
        root.right = delete(temp.value, root.right)
      end
    end
    return root
  end

  # [x] #find method which accepts a value and returns the node with the given value.
  # adapted from https://www.geeksforgeeks.org/binary-search-tree-set-1-search-and-insertion/?ref=lbp
  def find(value, root = @root)
    return root if root.nil? || root.value == value

    return find(value, root.right) if root.value < value

    return find(value, root.left)
  end

  # [x] #level_order method that returns an array of values.
  # This method should traverse the tree in breadth-first level order.
  # This method can be implemented using either iteration or recursion (try implementing both!).
  # Tip: You will want to use an array acting as a queue to keep track of all the child nodes
  # that you have yet to traverse and to add new ones to the list (as you saw in the video).
  # adapted from https://www.youtube.com/watch?v=86g8jAQug04
  def level_order
    return if @root.nil?

    values = []
    queue = []
    queue.push(@root)
    while !queue.empty?
      node = queue.shift
      values.push(node.value)
      queue.push(node.left) if node.left

      queue.push(node.right) if node.right

    end
    values
  end

  # [x] #inorder, #preorder, and #postorder methods that returns an array of values. Each method
  # should traverse the tree in their respective depth-first order.
  # adapted from https://www.youtube.com/watch?v=gm8DUJJhmY4
  def inorder(root, values = [])
    return if root.nil?

    inorder(root.left, values)
    values.push(root)
    inorder(root.right, values)
    values
  end

  def preorder(root, values = [])
    return if root.nil?

    values.push(root)
    preorder(root.left, values)
    preorder(root.right, values)
    values
  end

  def postorder(root, values = [])
    return if root.nil?

    postorder(root.left, values)
    postorder(root.right, values)
    values.push(root)
    values
  end

  def ordered_array(order_type)
    values = send(order_type, @root)
    values.map(&:value)
  end

  # [x] #depth method which accepts a node and returns the depth(number of levels) beneath the node.
  # algorithm from https://www.educative.io/edpresso/finding-the-maximum-depth-of-a-binary-tree
  def depth(node, count = 0)
    return count if node.nil?

    return count if node.left.nil? && node.right.nil?

    left_height = depth(node.left, count)
    right_height = depth(node.right, count)
    left_height > right_height ? count = left_height : count = right_height
    count += 1
  end

  # [x] #balanced? method which checks if the tree is balanced.
  # A balanced tree is one where the difference between heights of left subtree and right subtree
  # of every node is not more than 1.
  # algorithm from https://www.geeksforgeeks.org/how-to-determine-if-a-binary-tree-is-balanced/
  def balanced?(node = @root)
    return true if node.nil?

    return true if node.left.nil? && node.right.nil?

    if (depth(node.left) - depth(node.right)).abs <= 1
      balanced?(node.left) && balanced?(node.right) ? true : false
    end
  end

  # [x] #rebalance method which rebalances an unbalanced tree.
  # Tip: You’ll want to create a level-order array of the tree before passing the array back
  # into the #build_tree method.
  def rebalance
    @root = build_tree(level_order)
  end

=begin
  Write a simple driver script that does the following:

  [x] 1. Create a binary search tree from an array of random numbers
        (`Array.new(15) { rand(1..100) }`)
  [x] 2. Confirm that the tree is balanced by calling `#balanced?`
  [x] 3. Print out all elements in level, pre, post, and in order
  [x] 4. try to unbalance the tree by adding several numbers > 100
  [x] 5. Confirm that the tree is unbalanced by calling `#balanced?`
  [x] 6. Balance the tree by calling `#rebalance`
  [x] 7. Confirm that the tree is balanced by calling `#balanced?`
  [x] 8. Print out all elements in level, pre, post, and in order
=end

  def driver
    p balanced?
    p level_order
    p ordered_array(:preorder)
    p ordered_array(:postorder)
    p ordered_array(:inorder)
    insert(101)
    insert(303)
    insert(606)
    p balanced?
    rebalance
    p balanced?
    p level_order
    p ordered_array(:preorder)
    p ordered_array(:postorder)
    p ordered_array(:inorder)
  end

  # from the TOP instructions for this project
  def pretty_print(node = root, prefix="", is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? "│ " : " "}", false) if node.right
    puts "#{prefix}#{is_left ? "└── " : "┌── "}#{node.value.to_s}"
    pretty_print(node.left, "#{prefix}#{is_left ? " " : "│ "}", true) if node.left
  end
end

=begin
tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 6346, 6347, 324, 1001, 1002, 1003, 1004])
p tree.root
p tree.ary
tree.pretty_print
tree.insert(10)
tree.pretty_print
tree.insert(63)
tree.pretty_print
tree.insert(63)
tree.pretty_print
tree.delete(23)
tree.pretty_print
tree.delete(10)
tree.pretty_print
tree.delete(5)
tree.pretty_print
tree.delete(67)
tree.pretty_print
tree.delete(150)
tree.pretty_print
p tree.find(23)
p tree.find(1)
p tree.level_order
p tree.ordered_array(:inorder)
p tree.ordered_array(:preorder)
p tree.ordered_array(:postorder)
p tree.depth(tree.root)
p tree.balanced?
tree.insert(6348)
tree.pretty_print
p tree.balanced?
tree.rebalance
tree.pretty_print
p tree.balanced?
=end

ary = Array.new(15) { rand(1..100) }
tree_for_driver = Tree.new(ary)
tree_for_driver.driver