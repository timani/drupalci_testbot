<?php
function preg_grep_keys($pattern, $input, $flags = 0) {
  return array_intersect_key($input, array_flip(preg_grep($pattern, array_keys($input), $flags)));
}

function locate_binary($cmd) {
  return shell_exec("command -v $cmd");
}

