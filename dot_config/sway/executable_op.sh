#!/bin/bash

# Step 1: Get 1Password item ID
item_id=$(op item list --format json | \
    jq -r '.[] | "\(.title) - \(.additional_information // "")\t\(.id)"' | \
    wofi --dmenu --prompt "Select 1Password item:" --show dmenu --columns 1 --insensitive | \
    cut -f2)

# Exit if no item was selected
if [ -z "$item_id" ]; then
    echo "No item selected"
    exit 1
fi

# Step 2: Get the item data and let user choose which field to copy
item_data=$(op item get "$item_id" --format json)

# Show only labels in wofi, but use field IDs for uniqueness
selected_field_id=$(echo "$item_data" | \
    jq -r '.fields[]? | "\(.label)\t\(.id)"' | \
    wofi --dmenu --prompt "Select field to copy:" --show dmenu --columns 1 --insensitive | \
    cut -f2)

# Exit if no field was selected
if [ -z "$selected_field_id" ]; then
    echo "No field selected"
    exit 1
fi

# Get the value for the selected field ID and copy to clipboard
echo "$item_data" | \
    jq -r --arg field_id "$selected_field_id" '.fields[]? | select(.id == $field_id) | if .type == "OTP" then .totp // "" else .value // "" end' | \
    wl-copy
