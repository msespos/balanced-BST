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
# root attribute which uses the return value of #build_tree which you will write next.
class Tree
  attr_reader :ary, :root

  def initialize(ary)
    @ary = ary
    @root = build_tree(ary)
  end

  # [x] #build_tree method which takes an array of data
  # (e.g. [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]) and turns it into a balanced
  # binary tree full of Node objects appropriately placed (remember to sort and remove
  # duplicates!). The #build_tree method should return the level-1 root node.

  # from my merge sort project
  def merge(left, right)
    merged = []
    merged << (left.first <= right.first ? left : right).shift until left.empty? || right.empty?
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
    return if level_order(@root).include? value

    node = Node.new(value)
    insert_node(node)
  end

  # adapted from https://www.geeksforgeeks.org/binary-search-tree-set-2-delete/?ref=lbp
  def min_value_node(node)
    current = node
    current = current.left until current.left.nil?
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
    root
  end

  # [x] #find method which accepts a value and returns the node with the given value.
  # adapted from https://www.geeksforgeeks.org/binary-search-tree-set-1-search-and-insertion/?ref=lbp
  def find(value, root = @root)
    return root if root.nil? || root.value == value

    return find(value, root.right) if root.value < value

    find(value, root.left)
  end

  # [x] #level_order method that returns an array of values.
  # This method should traverse the tree in breadth-first level order.
  # This method can be implemented using either iteration or recursion (try implementing both!).
  # Tip: You will want to use an array acting as a queue to keep track of all the child nodes
  # that you have yet to traverse and to add new ones to the list (as you saw in the video).
  # adapted from https://www.youtube.com/watch?v=86g8jAQug04
  def level_order(root, values = [])
    return if root.nil?

    queue = []
    queue.push(root)
    until queue.empty?
      node = queue.shift
      values.push(node.value)
      queue.push(node.left) if node.left

      queue.push(node.right) if node.right

    end
    values
  end

  # print nodes at a given level (recursive version)
  # adapted from https://www.geeksforgeeks.org/level-order-tree-traversal/
  def print_given_level(root, level, values = [])
    return if root.nil?

    if level == 1
      values.push(root.value)
    elsif level > 1
      print_given_level(root.left , level-1, values)
      print_given_level(root.right , level-1, values)
    end
    values
  end

  # print level order traversal of tree (second version; calls a recursive method)
  # adapted from https://www.geeksforgeeks.org/level-order-tree-traversal/
  def print_level_order(root)
    values = []
    for i in 1..depth(root) + 1
      values.push(print_given_level(root, i)).flatten!
    end
    values
  end

  # [x] #inorder, #preorder, and #postorder methods that returns an array of values. Each method
  # should traverse the tree in their respective depth-first order.
  # adapted from https://www.youtube.com/watch?v=gm8DUJJhmY4
  def in_order(root, values = [])
    return if root.nil?

    in_order(root.left, values)
    values.push(root)
    in_order(root.right, values)
    values
  end

  def pre_order(root, values = [])
    return if root.nil?

    values.push(root)
    pre_order(root.left, values)
    pre_order(root.right, values)
    values
  end

  def post_order(root, values = [])
    return if root.nil?

    post_order(root.left, values)
    post_order(root.right, values)
    values.push(root)
    values
  end

  def order(order_type)
    values = send(order_type, @root)
    order_type == :level_order ? values : values.map(&:value)
  end

  # [x] #depth method which accepts a node and returns the depth(number of levels) beneath the node.
  # algorithm from https://www.educative.io/edpresso/finding-the-maximum-depth-of-a-binary-tree
  def depth(node, count = 0)
    return count if node.nil?

    return count if node.left.nil? && node.right.nil?

    left_height = depth(node.left, count)
    right_height = depth(node.right, count)
    left_height > right_height ? count = left_height : count = right_height
    count + 1
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
    else
      false
    end
  end

  # [x] #rebalance method which rebalances an unbalanced tree.
  # Tip: You will want to create a level-order array of the tree before passing the array back
  # into the #build_tree method.
  def rebalance
    @root = build_tree(level_order(@root))
  end

  # Write a simple driver script that does the following:
  # [x] 1. Create a binary search tree from an array of random numbers
  # [x] 2. Confirm that the tree is balanced by calling `#balanced?`
  # [x] 3. Print out all elements in level, pre, post, and in order
  # [x] 4. try to unbalance the tree by adding several numbers > 100
  # [x] 5. Confirm that the tree is unbalanced by calling `#balanced?`
  # [x] 6. Balance the tree by calling `#rebalance`
  # [x] 7. Confirm that the tree is balanced by calling `#balanced?`
  # [x] 8. Print out all elements in level, pre, post, and in order
  def driver
    p balanced?
    p order(:level_order)
    p print_level_order(@root)
    p order(:pre_order)
    p order(:post_order)
    p order(:in_order)
    insert(101)
    insert(303)
    insert(606)
    p balanced?
    rebalance
    p balanced?
    p order(:level_order)
    p print_level_order(@root)
    p order(:pre_order)
    p order(:post_order)
    p order(:in_order)
  end

  # from the TOP instructions for this project
  def pretty_print(node = root, prefix="", is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? "│ " : " "}", false) if node.right
    puts "#{prefix}#{is_left ? "└── " : "┌── "}#{node.value.to_s}"
    pretty_print(node.left, "#{prefix}#{is_left ? " " : "│ "}", true) if node.left
  end
end

ary = Array.new(15) { rand(1..100) }
Tree.new(ary).driver
