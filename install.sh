#!/usr/bin/env bash

echo "Copying 'juliaformatall' to '~/.local/bin/juliaformatall'"

mkdir -p "$HOME/.local/bin"
cp juliaformatall "$HOME/.local/bin"

echo 
echo 
echo "Make sure to set \$JULIAFORMATALL_HOME to this directory"
echo "in your ~/.bashrc or ~/.zshrc or etc file."
echo 
echo 
echo "For example:"
echo "    $ echo \"export JULIAFORMATALL_HOME='$(pwd)'\" >> ~/.bashrc"
echo "or"
echo "    $ echo \"export JULIAFORMATALL_HOME='$(pwd)'\" >> ~/.zshrc"
echo 
echo 
echo "Also, include ~/.local/bin in your path, for example"
echo "    $ echo \"export PATH=\\\"\\\$PATH:\\\$HOME/.local/bin\\\"\" >> ~/.bashrc"
echo "or"
echo "    $ echo \"export PATH=\\\"\\\$PATH:\\\$HOME/.local/bin\\\"\" >> ~/.zshrc"
