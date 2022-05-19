---
title: Part 14 - Splitting a Internal Node
date: 2022-05-19
---

If the internal node of our B+-tree is full, the process of out database will exit when inserting another cell to the internal node. Now it's time to working it out. I'm going to use the following example as a reference:

{% include image.html url="assets/images/splitting-internal-node.png" description="Example of splitting internal node" %}

In this example, we add the key “8” to the tree. That causes the [TODO] leaf node to split. After the split , a new leaf node is created, and we shoud add key “8” to the internal node. we fix up the tree by doing the following:




