#!/usr/bin/env bash

mkdir -p logs/

function run_ab() {
  gunicorn run_$1:app --config gunicorn_$1.conf &
  sleep 1
  PID=$!
  echo "Running bench with ab for $1"
  time ab -c 50 -n 1000 http://127.0.0.1:8000/$2 > logs/ab-$1.log
  kill $PID
  wait $PID
  sleep 1
}

function run_wrk() {
  echo "Running bench with wrk for $1"
  gunicorn run_$1:app --config gunicorn_$1.conf &
  sleep 1
  PID=$!
  curl -i http://127.0.0.1:8000/$2
  time wrk -t20 -c100 -d20s http://127.0.0.1:8000/$2 >> logs/wrk-$1.log
  kill $PID
  wait $PID
  if test -n "$3"
  then
    sleep $3
  fi
}

# Run a first test to warm up Memory/CPU/HTTP connections,
# this way the order of tests below should not anymore be significant.
# run_ab roll hello/bench

# run_ab sanic hello/bench
# run_ab aiohttp hello/bench
# run_ab falcon hello/bench
# run_ab roll hello/bench

run_wrk roll hello/bench 20
run_wrk sanic hello/bench 20
run_wrk roll hello/bench 20
run_wrk sanic hello/bench
# run_wrk aiohttp hello/bench
# run_wrk falcon hello/bench