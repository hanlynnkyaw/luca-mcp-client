# Luca MCP client

This folder connects Claude Code to the Luca accounting system. The
`luca` MCP server in `.mcp.json` is the only thing here; all bookkeeping
happens through its tools. There is no code in this repo to run or test.

## How to work

- This session was started for one client with `./luca <client>`, and its token
  sees exactly one company. Start by calling `list_companies`: it confirms the
  connection and names that company. Every other tool works on it.
- If the person asks about a different client, do not try to switch. Tell them
  to exit and run `./luca <that-client>`; a session never spans two clients.
- The tools speak accounting, not Luca: `record_sale`, `record_bill`,
  `receive_payment`, `pay_bills`, `post_journal`, `trial_balance` and so on.
  Read a tool's description before its first use; the server's own
  instructions carry the rules (for example, every write needs an
  `idempotency_key` taken from the source document).
- A write refused with 409 and an `existing_id` means that document is already
  in Luca from an earlier call. Treat it as done and look it up. Never retry
  with a new key: that books it twice.
- Documents post to the ledger the moment they are recorded. Say what you are
  about to record, with amounts and accounts, before you call a write tool.
  Afterwards report the document number and total that Luca returned.
- If you are unsure how something should be booked, look for a
  `luca://knowledge/...` resource first. If none covers it, ask the person.
- Luca's error text is authoritative. When a call is refused, repeat Luca's
  message to the person rather than guessing at a workaround.

## Never

- Never print, log or write the `LUCA_TOKEN` value anywhere, including chat.
- Never edit `.mcp.json` to hard-code a token or a company, and never read or
  quote the files in `clients/`.
- Never commit anything to this repo without being asked.
