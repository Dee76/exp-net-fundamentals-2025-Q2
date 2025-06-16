# :bricks: Windows Firewall Rules

## Testing Windows Firewall Rules

### Start Web Server

Following commands will start a _Python_-based web server on your local system running on port `8000`.

```sh
cd projects/windows_firewall_rules
python -m http.server 8000
```

> Connect to this server from your web browser using the address: `http://localhost:8000`

### Check Web Server from Terminal

You can check your web server from your terminal / command prompt by running the following command.

```sh
curl http://localhost:8000
```

## :book: Journal

To review how we tested _Windows Defender Firewall_ rules, and learn how to do it yourself, consult the [_Journal_](Journal.md).

:end: