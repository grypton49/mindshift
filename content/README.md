# MindShift puzzle content

This folder holds **`puzzles.json`** — the pack of puzzles the app loads. Editing
this file is how you add new problems **without shipping an app update**: players
fetch the latest pack on launch, cache it for offline use, and fall back to the
puzzles bundled in the app if the network is unavailable.

## The one rule

You can add any puzzle that **reuses a mechanic the app already ships** (see the
list below). A *brand-new kind of interaction* needs new app code — that still
requires a Play Store update. New content over an existing mechanic = instant.

If you add a puzzle whose `sandbox`/`answer`/`category` type an installed app
doesn't recognize, that app simply **skips** it (no crash) until it's updated.

## How to add a puzzle

1. Open `content/puzzles.json`.
2. Copy an existing entry in the `"puzzles"` array and edit its fields.
3. Give it a unique `"id"`.
4. Bump the top-level `"version"` number (optional, but nice for tracking).
5. Commit & push. Done — the app picks it up on next launch.

> Tip: after changing the **built-in** puzzles (the ones compiled into the app),
> regenerate this file so it stays in sync:
> `dart run tool/export_pack.dart > content/puzzles.json`

## Pack shape

```json
{
  "version": 1,
  "puzzles": [ /* Puzzle objects */ ]
}
```

## Puzzle object

| field           | type      | notes                                              |
|-----------------|-----------|----------------------------------------------------|
| `id`            | string    | unique; also the "solved" save key                 |
| `title`         | string    | short display title                                |
| `tagline`       | string    | one-line hook on the card                          |
| `category`      | enum      | `gameTheory` \| `math` \| `physics` \| `lateral`   |
| `difficulty`    | int 1–5   | display + ordering only                            |
| `prompt`        | string    | the problem + question (no hints about the method) |
| `rules`         | string[]  | bullet rules shown under the prompt                |
| `sandbox`       | object    | one of the sandbox types below                     |
| `answer`        | object    | one of the answer types below                      |
| `hints`         | string[]  | opt-in nudges — phrase as QUESTIONS, never answers  |
| `whyExplanation`| string?   | shown ONLY after the player solves it              |
| `comingSoon`    | bool      | optional; renders as a locked card                 |

## Sandbox types (the interactive experiment area)

- **Tigers & sheep induction** — pick a count, simulate a "bite":
  ```json
  { "type": "tigers", "minTigers": 1, "maxTigers": 12, "questionTigers": 100 }
  ```
- **Number tiles** — combine tiles to reach a target:
  ```json
  { "type": "numberTiles", "tiles": [2,3,5,7,9], "target": 17 }
  ```
- **Balance beam** — slide a weight to balance real torque:
  ```json
  { "type": "lever", "leftWeight": 4, "leftDistance": 3, "rightWeight": 3, "maxDistance": 5 }
  ```

## Answer types (how the player commits their conclusion)

- **Binary choice** (pairs with any sandbox; the sandbox stays exploration-only):
  ```json
  { "type": "binary", "question": "With 100 tigers, is the sheep…", "optionA": "Safe", "optionB": "Eaten", "correctIsA": true }
  ```
- **Reach a target** (pairs with `numberTiles`):
  ```json
  { "type": "reachTarget", "target": 17 }
  ```
- **Achieve a goal** (pairs with `lever`):
  ```json
  { "type": "goal", "goalLabel": "Balance the beam" }
  ```

## Design guardrail

MindShift's whole point is that **the human does the thinking**. Keep prompts
neutral, keep hints as questions, and never let a sandbox announce the verdict.
The `whyExplanation` is the only place you spell out the reasoning — and the app
only shows it after the player has solved the puzzle.
