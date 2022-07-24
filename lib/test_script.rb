require_relative "balanced_bst.rb"

tree = Tree.new((Array.new(15) { rand(1..100) }))
tree.build_tree

tree.pretty_print
puts ""
puts tree.balanced?
puts ""

tree.level_order{|nd| print "#{nd.data} "}
puts ""
tree.pre_order_traversal{|nd| print "#{nd.data} "}
puts ""
tree.in_order_traversal{|nd| print "#{nd.data} "}
puts ""
tree.post_order_traversal{|nd| print "#{nd.data} "}
puts ""

10.times{
    tree.insert(rand(101..150))
}
tree.pretty_print
puts ""
puts tree.balanced?
puts ""
tree.rebalance
tree.pretty_print
puts ""
puts tree.balanced?
puts ""

tree.level_order{|nd| print "#{nd.data} "}
puts ""
tree.pre_order_traversal{|nd| print "#{nd.data} "}
puts ""
tree.in_order_traversal{|nd| print "#{nd.data} "}
puts ""
tree.post_order_traversal{|nd| print "#{nd.data} "}
puts ""
