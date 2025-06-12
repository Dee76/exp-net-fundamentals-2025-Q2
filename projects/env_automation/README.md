# Environment Automation

## How to Deploy

### Check Your AWS Account

```sh
aws sts get-caller-identity
```

### Execute Deploy Script

```sh
cd /projects/env_automation
chmod +x ./bin/deploy
./bin/deploy
```

> The deploy script only has to have permissions changed via `chmod` once to make it executable.

## Journal

To review how we approached automating our environment and learn how to do it yourself, consult the [_Journal_](Journal.md).

:end: