#!/bin/bash

# Define swap file path
SWAP_File="/olspanel.swap"

# Get total RAM and current swap in MiB
Total_RAM=$(free -m | awk '/^Mem:/ { print $2 }')
Total_SWAP=$(free -m | awk '/^Swap:/ { print $2 }')

# Calculate required swap
Set_SWAP=$((Total_RAM - Total_SWAP))

# Only proceed if swap file doesn't exist
if [ ! -f "$SWAP_File" ]; then
  echo -e "🔍 Checking current SWAP setup...\n"

  if [[ $Total_SWAP -ge $Total_RAM ]]; then
    echo -e "✅ Sufficient swap already exists: ${Total_SWAP}MB"
  else
    # Limit swap size to 2048 MB max
    if [[ $Set_SWAP -gt 2048 ]]; then
      Set_SWAP=2048
    fi

    echo -e "🛠 Creating ${Set_SWAP}MiB swap file at $SWAP_File..."

    # Create swap file
    sudo fallocate -l "${Set_SWAP}M" "$SWAP_File" || sudo dd if=/dev/zero of="$SWAP_File" bs=1M count="$Set_SWAP"
    sudo chmod 600 "$SWAP_File"
    sudo mkswap "$SWAP_File"
    sudo swapon "$SWAP_File"

    # Add to fstab if not already present
    if ! grep -q "$SWAP_File" /etc/fstab; then
      echo "$SWAP_File swap swap sw 0 0" | sudo tee -a /etc/fstab > /dev/null
    fi

    # Set swappiness
    sudo sysctl vm.swappiness=10
    if ! grep -q "vm.swappiness" /etc/sysctl.conf; then
      echo "vm.swappiness = 10" | sudo tee -a /etc/sysctl.conf > /dev/null
    fi

    echo -e "\n✅ Swap of ${Set_SWAP}MiB set up successfully.\n"
    swapon --show
  fi
else
  echo -e "⚠️ Swap file already exists at $SWAP_File."
fi
