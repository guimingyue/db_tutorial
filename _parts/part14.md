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

Let's take an example of an internal node with the number of maximum keys of 3, and the root internal node is full with keys 7, 21, 28, as a result this node has four pointers. The result of the splitting of the leaf node is two leaf node with maximum key 14 and 21, so we should insert key key 14 into the parent internal node.

```diff

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




