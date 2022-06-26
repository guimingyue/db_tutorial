---
title: Part 14 - Splitting a Internal Node
date: 2022-05-19
---

If the internal node of our B+-tree is full, the process of out database will exit when inserting another cell to the internal node. Now it's time to working it out. I'm going to use the following example as a reference:

{% include image.html url="assets/images/splitting-internal-node.png" description="Example of splitting internal node" %}

In this example, we add the key "8" to the tree. That causes the third leaf node(with key 7 and key 9) to split. After the split , a new leaf node is created, and then the cell of key “8” should be added to the parent internal node, but now the internal node is full. We fix up the tree by splitting the internal node with the following steps after we finished the splitting of the third leaf node:

1. Update the old max key "9" in the parent to the new max key in the old leaf node "8".
2. Split the parent internal node and add a new child pointer/key pair to one of the splited internal node.




