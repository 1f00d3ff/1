#!/bin/bash

## Usage ./aisle7.sh git@github.com:<user>/repoName.git oldUser@domain.com newUser newUser@domain.com

git clone --bare "$1"
repoName=$(echo "$1" | grep -oE '(/[a-zA-Z0-9_]\.git$)' | sed 's/\///g')
cd "$repoName"

## source https://help.github.com/articles/changing-author-info/
git filter-branch --env-filter '
OLD_EMAIL="'$2'"
NEW_NAME="'$3'"
NEW_EMAIL="'$4'"
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$NEW_NAME"
    export GIT_COMMITTER_EMAIL="$NEW_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$NEW_NAME"
    export GIT_AUTHOR_EMAIL="$NEW_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags

## Hold onto your butts
git push --force --tags origin 'refs/heads/*'
cd ..
rm -rf "$repoName"
