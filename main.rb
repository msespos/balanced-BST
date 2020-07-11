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

  def initialize(ary)
    @ary = ary
    @root = build_tree(@ary)
  end

  # [x] #build_tree method which takes an array of data
    # (e.g. [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]) and turns it into a balanced
    # binary tree full of Node objects appropriately placed (don’t forget to sort and remove
    # duplicates!). The #build_tree method should return the level-1 root node.

  # from merge sort project
  def merge(left, right)
    merged = []
    until left.empty? || right.empty?
      merged << (left.first <= right.first ? left : right).shift
    end
    merged + (right.empty? ? left : right)
  end

  # from merge sort project
  def merge_sort(ary)
    return ary if ary.length == 1
    return merge(merge_sort(ary[0..ary.length / 2 - 1]), merge_sort(ary[ary.length / 2..-1]))
  end

  # from https://www.youtube.com/watch?v=VCTP81Ij-EM&feature=youtu.be
  def create_bst(ary, start, finish)
    return nil if start > finish
    midpoint = (start + finish) / 2
    root = Node.new(ary[midpoint])
    root.left = create_bst(ary, start, midpoint - 1)
    root.right = create_bst(ary, midpoint + 1, finish)
    return root
  end

  def build_tree(ary)
    ary = ary.uniq
    merge_sort(ary)
    create_bst(ary, 0, ary.length - 1)
  end

  # [] #insert and #delete method which accepts a value to insert/delete
    # (you’ll have to deal with several cases for delete such as when a node has children or not).
    # If you need additional resources, check out these two articles on inserting and deleting,
    # or this video with several visual examples.

  # [] #find method which accepts a value and returns the node with the given value.

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

end

tree = Tree.new([0])
p new_tree = tree.build_tree([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
p new_tree.value