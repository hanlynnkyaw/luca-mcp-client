# luca-mcp-client

Connects Claude Code to Luca so you can do bookkeeping by talking to it.
You work one client at a time: each client has its own token file, and you
start Claude Code by naming the client. One-time setup takes about five minutes.

## 1. Clone

```sh
git clone https://github.com/hanlynnkyaw/luca-mcp-client.git
cd luca-mcp-client
```

## 2. Get a token for one client

1. Sign in at https://app.luca.pro and select that client's company.
   The token is tied to the company selected when you create it.
2. Go to **Settings -> API Tokens** and click **Create token**.
3. Give it a name (for example `Claude Code`), pick an expiry, and create it.
4. Copy the token. Luca shows it once and never again. If you lose it, revoke it
   and create a new one.

API access needs the company to be on Luca Pro. A token made for the browser
extension will not work here.

## 3. Save it as a client file

Copy the template and name the file after the client:

```sh
cp clients/example.env clients/acme.env
```

Open `clients/acme.env` and paste the token after `LUCA_TOKEN=`. Repeat steps 2
and 3 for every client you work on. These files are ignored by git and stay on
your machine. Keep the token out of chat, screenshots and other files. Anyone
holding it can post to that company's books.

## 4. Start Claude Code for a client

macOS:

```sh
./luca acme
```

Windows (PowerShell):

```powershell
.\luca.ps1 acme
```

If PowerShell refuses to run the script, once:
`Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`.

Run it with no name to see which clients you have files for.

The first time, Claude Code asks whether to use the `luca` server from this
folder. Say yes. Then type `/mcp` and check that `luca` shows as connected.

## 5. Try it

Ask: "List my companies." You should get back the one company the token was
made for. Then ask for something real, for example "Show me the trial balance
for last month."

Lookups and reports run without asking. Anything that records or changes
something in the books asks you first, every time.

To work on another client, exit Claude Code and start it again with that
client's name. A session never sees more than one client.

## Local Luca

To test against a Luca running on your own machine, add this line to that
client's file:

```
LUCA_MCP_URL=http://127.0.0.1:8000/mcp
```

## If it does not connect

| You see | Cause | Fix |
|---|---|---|
| "has no token yet" | The file still holds the template text | Paste the token in |
| `luca` failed: "endpoint not found at ${LUCA_MCP_URL}" | Claude Code was started with plain `claude`, so no client was loaded | Exit and start it with `./luca <client>` |
| `luca` shows failed in `/mcp`, or 401 | Token mistyped or expired | Check the file; make a new token if it expired |
| 403 mentioning Pro | The company is not on Luca Pro | Upgrade the company, or use a token from a Pro company |
| 403 mentioning extension | You copied the browser extension's token | Create a token under Settings -> API Tokens instead |
| Tools work but show the wrong company | The token was created with another company selected | Make a token with the right company selected and replace it in the file |
