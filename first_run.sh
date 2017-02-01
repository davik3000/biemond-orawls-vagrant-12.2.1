#!/bin/bash
echo "-----"
echo "Booting up the nodes"
vagrant up admin
vagrant up node1
vagrant up node2

echo "-----"
echo "Applying provision to nodes"
vagrant provision

echo "-----"
echo "Reload the nodes to apply guest addition (1st)"
vagrant reload

echo "-----"
echo "Reload the nodes"
vagrant reload