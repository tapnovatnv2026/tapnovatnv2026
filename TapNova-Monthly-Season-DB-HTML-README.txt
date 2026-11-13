TAPNOVA MONTHLY SEASON - MISSIONS PANEL HTML UPDATE

Files
- TapNova-Monthly-Season-DB-HTML.html: updated HTML with a database-driven Missions panel.
- TapNova-Monthly-Season-Worker.js: matching Worker implementation.
- TapNova-Monthly-Season-DB-Migration.sql: required schema extension for mission event mapping and Energy-based character/shop prices.

Missions panel behavior
- Loads missions from POST /api/missions/list after Telegram authentication.
- Uses the Worker response fields: id, title, period, target, progress, complete, claimed, claimKey, rewardType, reward, and event.
- Filters Daily, Weekly, and Season tabs using the mission period returned by D1.
- Displays progress and TNV/Energy rewards from the API; no hard-coded mission list or locally fabricated progress remains in the Missions panel.
- Calls POST /api/missions/claim with the exact claimKey returned by the Worker.
- Updates the player balance/energy from the claim response and reloads mission state.
- Does not award rewards locally or bypass Worker verification.

Before deployment
1. Back up Cloudflare D1.
2. Apply TapNova-Monthly-Season-DB-Migration.sql exactly once. It uses ALTER TABLE ADD COLUMN and is not safe to run twice.
3. Deploy the matching TapNova-Monthly-Season-Worker.js.
4. Publish TapNova-Monthly-Season-DB-HTML.html to the existing frontend hosting location.
5. Test with a Telegram test account and staging D1 first. Confirm /api/missions/list returns the expected Daily/Weekly/Season rows and that a completed mission can be claimed once only.

Validation
- Extracted inline JavaScript passed `node --check`.
- This is a local syntax check only. No production Worker deployment, D1 migration, live Telegram request, or TON transaction was performed.
