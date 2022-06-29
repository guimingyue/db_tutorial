---
title: Part 14 - Splitting a Internal Node
date: 2022-05-19
---

If the internal node of our B+-tree is full, the process of out database will exit when inserting another cell to the internal node. Now it's time to working it out. I'm going to use the following example as a reference:

{% include image.html url="assets/images/splitting-internal-node.png" description="Example of splitting internal node" %}

In this example, we add the key "8" to the tree. That causes the third leaf node(with key 7 and key 9) to split. After the split , a new leaf node is created, and then the cell of key “8” should be added to the parent internal node, but now the internal node is full. We fix up the tree by splitting the internal node with the following steps after we finished the splitting of the third leaf node:

1. Update the old max key "9" in the parent to the new max key in the old leaf node "8".
2. Split the parent internal node and add a new child pointer/key pair to one of the splited internal node.

## Splitting Algorithm

Let's take an example of an internal node with the number of maximum keys of 3, and the root internal node is full with keys 7, 21, 28, so this node has four pointers. The result of the splitting of the leaf node is two leaf node with maximum key 14 and 21, so we should insert key key 14 into the parent internal node. The Splitting process just like this:
{% include image.html url="assets/images/internal-node-split-demo.png" description="splitting internal node" %}

## Splitting internal node 

So, let's going on with constants for splitting internal node.
```diff
+ const u_int32_t INTERNAL_NODE_RIGHT_SPLIT_COUNT = (INTERNAL_NODE_MAX_CELLS + 1) / 2;
+ const u_int32_t INTERNAL_NODE_LEFT_SPLIT_COUNT = (INTERNAL_NODE_MAX_CELLS + 1) - INTERNAL_NODE_RIGHT_SPLIT_COUNT - 1;
```
 And then, replace our stub code with two new function calls: internal_node_split_insert() for splitting internal node. 

 ```diff
if (original_num_keys >= INTERNAL_NODE_MAX_CELLS) {
-    printf("Need to implement splitting internal node\n");
-    exit(EXIT_FAILURE);
+    internal_node_split_insert(table, parent_page_num, child_max_key, child_page_num);
+    return;
}
 ```

 In our new function, we create a new internal node and initialize this node. The last two parameters of our new function internal_node_split_insert is the key and page pointer, or page number.

 ```diff
+ void internal_node_split_insert(Table* table, uint32_t parent_page_num, uint32_t insert_cell_key, uint32_t insert_page_num) {
+    uint32_t new_internal_page_num = get_unused_page_num(table->pager);
+    void* new_node = get_page(table->pager, new_internal_page_num);
+    initialize_internal_node(new_node);

 ```

Firstly, if the maximum size of internal node is greater than 3, the index of key 14 should be 1 (0-based) of the key array. So we update the key of index 1 with 14, which means replacing key 21 with key 14. As a result, the (left) pointer of key 14 points to the leaf node with maximum key of 14. 

```diff

```

Secondly, create a new internal node, and move half of the key and pointers to the new internal node.
    - if the new key to be added is larger than the maximum key of the internal node, the key 21 and the number of page key 21 blonging to to 
    - if the new key to be added is 

Thirdly, if the internal is the root node, than create a new root node as [part 10](./part10.md) explained.

```diff

```




