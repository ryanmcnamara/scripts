#!/bin/zsh

set -euo pipefail

tmpfile=$(mktemp)
echo tmpfile $tmpfile

curl 'https://data.typeracer.com/games?startDate=0&endDate='"$(date +%s)"'&universe=play&playerId=tr:ryan10132&n=10000&callback=__gwt_callback572414882' \
  -H 'authority: data.typeracer.com' \
  -H 'accept: */*' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'cookie: '"$COOKIE_HEADER_VALUE"'' \
  -H 'dnt: 1' \
  -H 'referer: https://play.typeracer.com/' \
  -H 'sec-ch-ua: "Not?A_Brand";v="8", "Chromium";v="108", "Google Chrome";v="108"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: script' \
  -H 'sec-fetch-mode: no-cors' \
  -H 'sec-fetch-site: same-site' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36' \
  --compressed > $tmpfile
echo "timestamp, game number, words per minute"
cat $tmpfile | sed 's/^[^(]*(//' | sed 's/)[^)]*$//' | jq '.[] | "\(.t),\(.gn),\(.wpm)"' -r
