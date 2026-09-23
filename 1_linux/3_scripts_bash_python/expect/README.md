# Expect Examples

- [`ssh-kras.exp.sh`](ssh-kras.exp.sh) — the original working example with `PASS` and `MY_USER` variables. Its content is preserved unchanged.
- [`expect.sh`](expect.sh) — the original notes and an alias configuration example.
- [`ssh-interactive-sudo.exp`](ssh-interactive-sudo.exp) — an additional variant where SSH and `sudo` handle the authentication prompts themselves, and Expect only launches the interactive session and returns its exit status.

The new variant does not replace the original one:

```bash
expect ./ssh-interactive-sudo.exp server.example admin_user

# Or with a user from the environment
SSH_USER=admin_user expect ./ssh-interactive-sudo.exp server.example
```

For permanent automation, SSH keys, certificates, or a centralized access proxy are preferred. Verify the host fingerprint before connecting to a critical system for the first time.
