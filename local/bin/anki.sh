#!/usr/bin/env bash
exec setsid -f /usr/bin/anki "$@" </dev/null >/dev/null 2>&1
q