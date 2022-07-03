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

As the part 10 did, we should update the key of the internal node after the splitting of child leaf node. So, in our example above, if the maximum size of internal node is greater than 3, the index of key 14 should be 1 (0-based) of the key array. So we update the key of index 1 with 14, which means replacing key 21 with key 14. As a result, the (left) pointer of key 14 points to the leaf node with maximum key of 14. Then add key 21 and page number to the parent internal node. But the maximum size of internal node is 3, so we should split the internal node.

## Splitting internal node 

So, let's going on with constants for splitting internal node.
```diff
+ const u_int32_t INTERNAL_NODE_RIGHT_SPLIT_COUNT = (INTERNAL_NODE_MAX_CELLS + 1) / 2;
+ const u_int32_t INTERNAL_NODE_LEFT_SPLIT_COUNT = (INTERNAL_NODE_MAX_CELLS + 1) - INTERNAL_NODE_RIGHT_SPLIT_COUNT - 1;
```
 And then, replace our stub code with the new function calls: `internal_node_split_insert()` for splitting internal node. 

 ```diff
+ if (original_num_keys >= INTERNAL_NODE_MAX_CELLS) {
-   printf("Need to implement splitting internal node\n");
-   exit(EXIT_FAILURE);
+   internal_node_split_insert(table, parent_page_num, child_max_key, child_page_num);
+   return;
+ }
 ```

 The last two parameters of our new function `internal_node_split_insert` is the key and page pointer, or page number, to be added into parent internal node. In our new function, we first create a new internal node and initialize this node. 

 ```diff
+ void internal_node_split_insert(Table* table, uint32_t parent_page_num, uint32_t insert_cell_key, uint32_t insert_page_num) {
+   uint32_t new_internal_page_num = get_unused_page_num(table->pager);
+   void* new_node = get_page(table->pager, new_internal_page_num);
+   initialize_internal_node(new_node);
+   *node_parent(new_node) = parent_page_num;
+ }
 ```
Find the right child for the new internal node and set the value. It should be noted that the right child for the new internal node should be either the right child of the old node or the new page number to be added. If the right child of the new internal node is the one of the old node, so just assign the page number to the right child of the new internal node, or we should assign the new page number to be added to the target right child and replace the key and page number to be added with the max key of the right child of the old internal node and the corresponding page number.

```diff
+ void* old_node = get_page(table->pager, parent_page_num);
+ int32_t right_child_page_num = *internal_node_right_child(old_node);
+ void* right_child = get_page(table->pager, right_child_page_num);
+ // move right child
+ int32_t cur_right_child_max_key = get_node_max_key(right_child);
+ if (insert_cell_key > cur_right_child_max_key) {
+   *internal_node_right_child(new_node) = insert_page_num;
+   insert_cell_key = cur_right_child_max_key;
+   insert_page_num = right_child_page_num;
+ } else {
+   *internal_node_right_child(new_node) = right_child_page_num;
+}
```
Then we move half of the key and pointers to the new internal node. First We should find the right postion of the new key should be by invoking the function `internal_node_find_child`.

```diff
+ // find cell num of insert_cell_key
+ uint32_t cell_num = internal_node_find_child(old_node, insert_cell_key);
+ *internal_node_num_keys(new_node) = INTERNAL_NODE_RIGHT_SPLIT_COUNT;
+ int32_t i = INTERNAL_NODE_MAX_CELLS;
+ for ( ; i >= INTERNAL_NODE_RIGHT_SPLIT_COUNT; i--) {
+   uint32_t index_within_node = i % INTERNAL_NODE_RIGHT_SPLIT_COUNT;
+   void* destination = internal_node_cell(new_node, index_within_node);
+   if (i == cell_num) {
+       *internal_node_key(new_node, index_within_node) = insert_cell_key;
+       *internal_node_child(new_node, index_within_node) = insert_page_num;
+   } else if (i > cell_num) {
+       memcpy(destination, internal_node_cell(old_node, i - 1), INTERNAL_NODE_CELL_SIZE);
+   } else {
+       memcpy(destination, internal_node_cell(old_node, i), INTERNAL_NODE_CELL_SIZE);
+   }
+ }
```
After that, both right child and half of the keys and pointers are moved out from the old internal node, so we  must find a new right child for this internal node, and the righthmost remaing page number or the new added page number should the choice.

```diff
+ if (i == cell_num) {
+   *internal_node_right_child(old_node) = insert_page_num;
+ } else {
+   *internal_node_right_child(old_node) = *internal_node_child(old_node, i);
+ }
```

If the new key and page number(or pointer) should be added into the old internal node, the we should move some keys and pointers to make room for new cell.

```diff
+ i--;
+ *internal_node_num_keys(old_node) = INTERNAL_NODE_LEFT_SPLIT_COUNT;
+ for (; i >= 0; i--) {
+   uint32_t index_within_node = i % INTERNAL_NODE_LEFT_SPLIT_COUNT;
+   void* destination = internal_node_cell(old_node, index_within_node);
+   if (i == cell_num) {
+       *internal_node_key(old_node, index_within_node) = insert_cell_key;
+       *internal_node_child(old_node, index_within_node) = insert_page_num;
+    } else if (i > cell_num) {
+       memcpy(destination, internal_node_cell(old_node, i - 1), INTERNAL_NODE_CELL_SIZE);
+    } else {
+       continue;
+    }
+ }
```

If the old internal node is the root node, then we should create a new root node as [part 10](./part10.md) explained.

```diff
+ bool node_root = is_node_root(old_node);
+ if (node_root) {
+   create_new_root(table, new_internal_page_num);
+ } else {
+   printf("Need to implement insert new internal page to parent node\n");
+   exit(EXIT_FAILURE);
+ }
```

At this moment, we can split the internal node if this node is full, but the new function has not been tested. So in the next part we will add some tests to see if this function could work as we expected.




