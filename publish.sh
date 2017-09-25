#!/bin/sh

message=$1

if [ -z $message ]
then 
    echo "You must have a message."
    exit 1;
fi

branch=$(git symbolic-ref --short HEAD)
source="source"

echo $branch

if [ $branch != $source ]
then 
    echo "You must be in source branch to publish."
    exit 1;
fi

if [[ $(git status -s) ]]
then
    git add .
    git commit -m "$message"
fi

echo "Generating site"
rm -rf docs
hugo

echo "Moving the docs folder to one level above"
mv docs ..

echo "Checkout master" 
git checkout master
echo "Move the content of the docs folder to the master branch"
rm -rf *
mv ../docs/* .
rm -rf ../docs
echo "Push the changes with comment: $message"
git add .
git commit -m "$message"
git push origin master

echo "Checkout source and push the commit to the repo"
git checkout source
git push origin source
