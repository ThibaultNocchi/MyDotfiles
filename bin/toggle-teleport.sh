#!/usr/bin/env bash

mapfile -t FILES < <(find ~/.tsh -maxdepth 1 -type f -name '*.yaml' -print0 | xargs -0 basename -s .yaml)
CURRENT=$(cat ~/.tsh/current-profile)

echo Available profiles: ${FILES[*]}
echo Current profile: $CURRENT

CURRENT_INDEX=0

for i in "${!FILES[@]}"; do
	if [[ "${FILES[$i]}" = "${CURRENT}" ]]; then
		CURRENT_INDEX=${i};
		break;
	fi
done

CURRENT_INDEX=$(((CURRENT_INDEX+1) % ${#FILES[@]}))

echo New profile: ${FILES[$CURRENT_INDEX]}
echo -n ${FILES[$CURRENT_INDEX]} > ~/.tsh/current-profile
