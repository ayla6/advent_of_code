#!/usr/bin/env fish
# dumb little fun test to compare the runtimes

set year (count $argv > /dev/null && echo $argv[2] || echo 2015)
set day (count $argv > /dev/null && echo $argv[1] || echo 1)

cd "2015/$day/gleam"
gleam build --target erlang
gleam build --target javascript

echo "=== Day $day Benchmark ==="
echo ""

echo "Single run:"
echo ""
hyperfine --warmup 1 \
  -n 'Bun' 'bun -e "const { main } = await import(\"./build/dev/javascript/main/main.mjs\"); main();"' \
  -n 'BEAM' 'erl -noshell -pa build/dev/erlang/*/ebin -eval "main:main()" -s init stop'

echo ""
echo "100 iterations (sustained):"
echo ""
hyperfine --warmup 1 \
  -n 'Bun' 'bun -e "const { main } = await import(\"./build/dev/javascript/main/main.mjs\"); for (let i = 0; i < 100; i++) main();"' \
  -n 'BEAM' 'erl -noshell -pa build/dev/erlang/*/ebin -eval "lists:foreach(fun(_) -> main:main() end, lists:seq(1, 100)), init:stop()"'
