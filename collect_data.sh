#!/bin/sh

GIT_DIR=$1
OUTPUT_FILE=data_file

function display_stats {
  (for rev in `revisions | head -n $1`; do
    echo "`number_of_lines`, `commit_time`, `commit_author`"
  done) | tee $OUTPUT_FILE
}

function revisions {
  git_with_dir rev-list HEAD
}

function commit_time {
  git_with_dir show -s --format="%ci" $rev
}

function commit_author {
  git_with_dir show -s --format="%aN" $rev
}

function number_of_lines {
  git_with_dir ls-tree -r $rev |
  awk '{print $3}' |
  # unfortunately xargs invokes command in new shell; don't want to overdo
  xargs git --git-dir="$GIT_DIR/.git" --work-tree="$GIT_DIR" show $@ |
  wc -l
}

function git_with_dir {
  git --git-dir="$GIT_DIR/.git" --work-tree="$GIT_DIR" $@
}

if [ -z "$GIT_DIR" ]; then
  echo "Please specify git directory."
else
  display_stats 100
fi

