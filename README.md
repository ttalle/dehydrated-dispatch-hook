# Dehydrated dispatch hook

Since [Dehydrated](https://dehydrated.de) only has a single HOOK parameter
you can use this script to dispatch the hooks to multiple hook-scripts.

## Dependencies

Nothing special, only Bash.

## Usage

Set this script as your HOOK script in Dehydrated and create a configuration
file as ```/etc/dehydrated/dispatch-hooks.inc```. It should look like the following:

```bash
#!/usr/bin/env bash

HOOKS=(
        "/opt/dehydrated-hook/hook1.sh"
        "/opt/dehydrated-hook/hook2.sh"
)
```

The hooks will run in the specified order.

## Why also an complicated version of this script?

Well, sometimes you start writing really great code with function caching and
cool existence checks. Then, when you do a debug run, you discover it could've
been done in two lines.

So, dehydrated-dispatch-hook.sh is the two-line variant.
