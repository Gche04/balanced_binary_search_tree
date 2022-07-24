
class Node
    attr_accessor :data, :left_node, :right_node
    def initialize(data)
        @data = data
        @left_node = nil
        @right_node = nil
    end
end

class Tree
    def initialize(array)
        @array = array.uniq.sort
        @root = nil
    end

    def build_tree
        @root = build(@array, 0, @array.length-1)
    end

    def insert(val)
        create_insert(val)
    end

    def create_insert(val, rt = @root)
        return rt = Node.new(val) if rt == nil
            
        if rt.data > val
            rt.left_node = create_insert(val, rt.left_node)
        elsif rt.data < val
            rt.right_node = create_insert(val, rt.right_node)
        end
        rt
    end

    def delete(val)
        node = find(val, @root)
        p = find_parent(val, @root)

        if is_leaf(val)
            unless p.right_node == nil
                p.right_node = nil if p.right_node.data == val
            end    
            unless p.left_node == nil
                p.left_node = nil if p.left_node.data == val
            end

        elsif one_child(val)
            unless node.right_node == nil
                p.right_node = node.right_node if p.right_node.data == val    
            else
                p.left_node = node.left_node if p.left_node.data == val
            end

        elsif two_children(val)
            if is_leaf(inorder_suc(val).data)
                hold_val = inorder_suc(val).data
                delete(hold_val)    
                node.data = hold_val
            else
                hold_val = order_suc(val).data
                delete(hold_val)
                node.data = hold_val
            end
        end
    end

    def build(arr = @array, start, last)
        return nil if start > last

        mid = (start + last)/2
        node = Node.new(arr[mid])

        node.left_node = build(arr, start, mid-1)
        node.right_node = build(arr, mid + 1, last)
        node
    end

    def find(val, rt = @root)
        if val == rt.data
            return rt
        else
            node = nil
            unless rt.left_node == nil
                node = find(val, rt.left_node) if val < rt.data
            end

            unless rt.right_node == nil
                node = find(val, rt.right_node) if val > rt.data
            end
            
            return node
        end
    end

    def level_order
        return if @root == nil
        arr = []
        arr << @root 
        
        until arr.empty?
            yield arr[0] unless arr[0] == nil
            arr << arr[0].left_node unless arr[0].left_node == nil
            arr << arr[0].right_node unless arr[0].right_node == nil
            arr.delete_at(0)
        end
    end

    def pre_order_traversal
        arr = pre_order_arr
        if block_given?
            arr.each {|i| yield i} 
        else
            data_arr = []
            arr.each {|i| data_arr << i.data}
            print data_arr
        end
    end

    def pre_order_arr(rt = @root, arr = [])
        return if rt == nil
        arr << rt
        pre_order_arr(rt.left_node, arr) if rt && rt.left_node
        pre_order_arr(rt.right_node, arr) if rt && rt.right_node
        arr
    end

    def in_order_traversal
        arr = in_order_arr
        if block_given?
            arr.each {|i| yield i} 
        else
            data_arr = []
            arr.each {|i| data_arr << i.data}
            print data_arr
        end
    end

    def in_order_arr(rt = @root, arr = [])
        return if rt == nil
        in_order_arr(rt.left_node, arr) if rt && rt.left_node
        arr << rt
        in_order_arr(rt.right_node, arr) if rt && rt.right_node
        arr
    end

    def post_order_traversal
        arr = post_order_arr
        if block_given?
            arr.each {|i| yield i} 
        else
            data_arr = []
            arr.each {|i| data_arr << i.data}
            print data_arr
        end
    end

    def post_order_arr(rt = @root, arr = [])
        return if rt == nil
        post_order_arr(rt.left_node, arr) if rt && rt.left_node
        post_order_arr(rt.right_node, arr) if rt && rt.right_node
        arr << rt
        arr
    end

    def height(node)
        return 0 if node == nil

        lft_node = height(node.left_node)
        rht_node = height(node.right_node)

        if lft_node > rht_node
            return lft_node + 1 
        else
            return rht_node + 1
        end
    end

    def depth(node)
        return nil if node == nil

        p = find_parent(node.data)
        return 1 if p == node
        return depth(p) + 1
    end

    def balanced?(rt = @root)
        left_height = left_node_height(rt)
        right_height = right_node_height(rt)
        
        difference = left_height - right_height if left_height >= right_height
        difference = right_height - left_height if right_height >= left_height

        return true if difference <= 1
        false
    end

    def rebalance(rt = @root)
        unless balanced?(rt)
            new_arr = []
            post_order_traversal{|i| new_arr << i.data}
            @array = new_arr.uniq.sort
            build_tree
        end
    end

    def left_node_height(rt = @root)
        return -1 if rt == nil
        return left_node_height(rt.left_node) + 1
    end

    def right_node_height(rt = @root)
        return -1 if rt == nil
        return right_node_height(rt.right_node) + 1
    end
    
    def inorder_suc(val)
        node = find(val, @root)
        return nil unless node

        unless is_leaf(val) || node.left_node == nil
            l_child = find(node.left_node.data, @root)
            while l_child.right_node 
                l_child = find(l_child.right_node.data, @root)
            end
            return l_child 
        end

        p = parent(val)
        until p.data < node.data
            return nil if p.data == parent(p.data)
            p = parent(p.data)
        end
        p
    end

    def order_suc(val)
        node = find(val, @root)
        return nil unless node

        if is_leaf(val)
            p = parent(val)
            until p.data > node.data
                return nil if p.data == parent(p.data)
                p = parent(p.data)
            end
            return p
        end
        
        return node.right_node if node.right_node.left_node == nil

        c = node.right_node.left_node
        while c.left_node
            c = c.left_node
        end
        c
    end

    def two_children(val)
        nd = find(val, @root)
        if nd == 0
            return false
        else
            if nd.left_node != nil && nd.right_node != nil
                return true
            else
                return false
            end
        end
    end

    def one_child(val)
        nd = find(val, @root)
        if nd == 0
            return false
        else
            if nd.left_node == nil && nd.right_node != nil
                return true
            elsif nd.left_node != nil && nd.right_node == nil
                return true
            else
                return false
            end
        end
    end

    def is_leaf(val)
        nd = find(val, @root)
        if nd == 0
            return false
        else
            if nd.left_node == nil && nd.right_node == nil
                return true
            else
                return false
            end
        end
    end

    def find_parent(val, rt = @root)
        nd = find(val, rt)
        if nd == rt
            return nd
        elsif nd == rt.right_node || nd == rt.left_node
            return rt
        else
            return node = find_parent(val, rt.left_node) if val < rt.data
            return node = find_parent(val, rt.right_node) if val > rt.data
        end
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
        pretty_print(node.right_node, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_node
       puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
       pretty_print(node.left_node, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_node
   end
end
