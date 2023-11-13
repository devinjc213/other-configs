#!/bin/bash

BASE_DIR="$HOME/drive/dashboard-laravel"
frontend="frontend"
backend="backend"
utils="utils"
FRONTENDEXISTS=$(tmux list-sessions | grep $frontend)
BACKENDEXISTS=$(tmux list-sessions | grep $backend)
UTLSEXISTS=$(tmux list-sessions | grep $utils)

tmux rename-session -t $(tmux display-message -p '#S') 'editor'
tmux rename-window -t editor:0 'vim'
tmux send-keys -t editor:0 'cd ~/drive/dashboard-laravel' C-m
tmux send-keys -t editor:0 'vim .' C-m

if [ "$FRONTENDEXISTS" = "" ]
then
  cd $BASE_DIR/client
  tmux new-session -d -s $frontend
  tmux rename-window -t $frontend:0 'client'
  tmux send-keys -t $frontend:0 'npm run start' C-m
  cd $BASE_DIR/admin
  tmux new-window -t $frontend:1 -n 'admin'
  tmux send-keys -t $frontend:1 'npm run start' C-m
  cd $BASE_DIR/builder
  tmux new-window -t $frontend:2 -n 'builder'
  tmux send-keys -t $frontend:2 'npm run start' C-m
fi

if [ "$BACKENDEXISTS" = "" ]
then
  cd $BASE_DIR/nest
  tmux new-session -d -s $backend
  tmux rename-window -t $backend:0 'nest'
  tmux send-keys -t $backend:0 'npm run start:dev' C-m
  cd $BASE_DIR/ingest
  tmux new-window -t $backend:1 -n 'ingest'
  tmux send-keys -t $backend:1 'npm run start:dev' C-m
  cd $BASE_DIR/api
  tmux new-window -t $backend:2 -n 'php'
  tmux send-keys -t $backend:2 'php artisan serve' C-m
  cd $BASE_DIR/digest
  tmux new-window -t $backend:3 -n 'digest'
  tmux send-keys -t $backend:3 'npm run start:dev' C-m
fi

if [ "$UTILSEXISTS" = "" ]
then
  cd $BASE_DIR/scripts
  tmux new-session -d -s $utils
  tmux rename-window -t $utils:0 'scripts'
fi
