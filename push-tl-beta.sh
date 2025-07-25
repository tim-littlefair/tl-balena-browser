#!/bin/sh

# Beta suffix includes id of upstream base commit from b-i-o/browser
# Usually this will be the commit tagged with the version number
# but including it here gives us the capability to have traceability
# to upstream commits which are not tagged as a version.
upstream_base_commit=2a79288
tl_beta_seq=$1
beta_suffix=$upstream_base_commit.$tl_beta_seq

branch_status=$(git status | grep -q "On branch tl-betas" )
if [ ! "$?" = "0" ]
then
    echo This script must be run against branch tl-betas
    exit 1
fi

version_diff_status=$(git diff -n VERSION balena.yml)
if [ ! "$?" = "0" ]
then
    echo This script cannot be run if VERSION or balena.yml are modified
    exit 2
fi


# Edit balena.yml and VERSION to reflect the beta numbering
sed -e "/version:/s/$/-$beta_suffix/" -i balena.yml
sed -e "1s/$/-$beta_suffix/" -i VERSION
git diff

# Do the push
push_command="balena push gh_tim_littlefair/tl-browser-aarch64"
echo Push command will be: $push_command
echo About to start push at $(date --utc)
$push_command
push_status=$?
echo Push completed at $(date --utc)


if [ "$push_status" = "0" ]
then 
    echo Push succeeded, creating branch and tag
    git checkout -b $beta_suffix-branch
    git commit . -m "Beta version $beta_suffix as pushed to BalenaHub"
    git tag $beta_suffix
    echo Push content has been branched, committed and tagged locally only
    echo run "git push $beta_suffix $beta_suffix-branch" or similar manually 
    echo to reflect these commits and refs at GitHub
    git checkout tl-betas
else
    echo Push command failed with status $push_status
    echo No branches, commits or tags have been created
fi

git restore balena.yml VERSION


