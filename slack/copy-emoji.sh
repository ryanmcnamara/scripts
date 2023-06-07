#!/bin/bash
set -euo pipefail

# Check if the required command line arguments are provided
if [[ $# -ne 4 ]]; then
    echo "Usage: $0 <source_slack_url> <target_slack_url> <from_emoji_name> <to_emoji_name>"
    exit 1
fi

# Assign the command line arguments to variables
source_slack_url=$1
target_slack_url=$2
from_emoji_name=$3
to_emoji_name=$4

# Check if the required environment variables are set
if [[ -z $SOURCE_SLACK_TOKEN ]] && [[ -z $SOURCE_SLACK_COOKIE ]]; then
    echo "Either SOURCE_SLACK_TOKEN or SOURCE_SLACK_COOKIE environment variable must be set."
    exit 1
fi

if [[ -z $TARGET_SLACK_TOKEN ]] && [[ -z $TARGET_SLACK_COOKIE ]]; then
    echo "Either TARGET_SLACK_TOKEN or TARGET_SLACK_COOKIE environment variable must be set."
    exit 1
fi

echo source slack url $source_slack_url
response=$(curl "$source_slack_url/api/emoji.list" \
        -H "Cookie: $SOURCE_SLACK_COOKIE" \
        -F token=$SOURCE_SLACK_TOKEN \
        -F count=100
    )

response_file=$(mktemp)
echo $response > $response_file
echo response written to $response_file

# Check if the API request was successful
if [[ $(echo "$response" | jq -r '.ok') != true ]]; then
    echo "Failed to fetch emojis from the source Slack instance."
    exit 1
fi

# Get the URL of the emoji from the API response
emoji_url=$(echo "$response" | jq -r ".emoji.\"$from_emoji_name\"")

echo $emoji_url

# Check if the emoji exists
if [[ $emoji_url == null ]]; then
    echo "Emoji '$from_emoji_name' does not exist in the source Slack instance."
    exit 1
fi

download_file="$(mktemp).png"
curl -k $emoji_url > $download_file
echo temp download at $download_file

curl  \
        -H "Cookie: $TARGET_SLACK_COOKIE" \
        -F token=$TARGET_SLACK_TOKEN \
        -F name=$to_emoji_name \
        -F image="@$download_file" \
        -F mode=data \
        -X POST "$target_slack_url/api/emoji.add"

# Check if the API request was successful
#if [[ $(echo "$upload_response" | jq -r '.ok') != true ]]; then
    #echo "Failed to upload the emoji to the target Slack instance."
    #exit 1
#fi

# echo "Emoji '$to_emoji_name' has been successfully copied to the target Slack instance."
