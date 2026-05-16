# Git Authentication Fallback & Debugging Flow

This document captures a real-world debugging session where standard `gh` and `git` authentication methods failed, and the final solution that worked. Use this as a guide when you encounter stubborn `git clone` authentication failures.

## The Problem
`git clone` of a private repository fails with `fatal: could not read Username for 'https://github.com': No such device or address`, even when `gh auth status` reports successful authentication via a `GITHUB_TOKEN` environment variable.

This indicates that `git` is not correctly using `gh` as its credential helper, despite `gh` itself being authenticated.

## Debugging & Resolution Path

This was the sequence of attempts, from most modern to most basic.

### Attempt 1: Standard `gh` Integration (Failed)

- **Action**: Assuming `gh` being authenticated is enough.
- **Command**: `git clone https://...`
- **Result**: Failure. `git` still tries to prompt for a password.
- **Lesson**: `gh auth status` being "ok" does not guarantee `git` is configured to use it.

### Attempt 2: Explicitly Configure `git` to use `gh` (Failed)

- **Action**: Manually tell `git` to use `gh` as its credential helper.
- **Command**: `git config --global credential.helper "gh auth git-credential"`
- **Result**: Failure with `git: 'credential-gh' is not a git command.`
- **Lesson**: This error indicates an old or non-standard installation of `git` or `gh`, where the integration helper is not correctly registered in the system's PATH or git's configuration.

### Attempt 3: URL-based Token Authentication (SUCCESS)

This is the most robust fallback method. It bypasses all credential helpers and embeds the authentication directly into the clone URL. It is less elegant but highly reliable.

**Workflow:**

1.  **Extract the Token**: Ensure the `GITHUB_TOKEN` is available.
    ```bash
    export GITHUB_TOKEN=$(grep GITHUB_TOKEN ~/.hermes/.env | cut -d= -f2)
    ```

2.  **Construct the Authenticated URL**:
    ```python
    repo_url = "https://github.com/owner/repo.git"
    repo_url_no_protocol = repo_url.split("://")[1]
    authenticated_url = f"https://{github_token}@{repo_url_no_protocol}"
    ```

3.  **Clone using the special URL**:
    ```bash
    git clone "https://<YOUR_TOKEN_HERE>@github.com/owner/repo.git" /path/to/clone
    ```

4.  **(CRITICAL) Clean Up for Security**: After cloning, the remote URL stored in the local repository's `.git/config` will contain your token in plaintext. **You must remove it immediately.**
    ```bash
    # Navigate into the new repository
    cd /path/to/clone

    # Reset the remote URL to the standard, unauthenticated version
    git remote set-url origin https://github.com/owner/repo.git
    ```

This final method proved effective when all others failed and should be considered the ultimate fallback for cloning private repositories in difficult environments.
