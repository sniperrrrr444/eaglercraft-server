# Contributing

Thanks for helping improve the project.

## Before opening an issue

Please check the README and existing issues first.

## Bug reports

Include:

- ChromeOS version and Linux environment.
- CPU architecture (`uname -m`).
- `java -version`.
- Paper version.
- EaglerXServer version.
- The relevant lines from `server-console.log` and `tunnel.log`.
- Exact command that failed.

Remove passwords, tokens, private keys and other secrets before posting logs.

## Pull requests

Good contributions include:

- reproducible fixes;
- compatibility improvements;
- documentation corrections;
- startup/diagnostic improvements;
- tested plugin compatibility information.

Avoid committing generated worlds, credentials, certificates or huge binary files.

## Testing

Before submitting a change, test the affected path from a clean Linux environment when possible:

```bash
./install.sh
./start.sh
```

For public networking:

```bash
./start-public.sh
```

Confirm that shutdown also cleans up the processes it created.

## Compatibility

Do not assume that a plugin or modern Minecraft version is compatible with Paper 1.12.2/EaglerXServer. Record the exact versions you tested.
