---
name: jujutsu
description: Use Jujutsu (jj) for ALL version-control operations in a repo that has a .jj/ directory. Assumes you already know jj mechanically; focuses on agent judgment — safe history surgery, splitting work into clean logical commits, recovering from mistakes, verifying rewrites, and operating within first- and second-order megamerges (multi-stream work). Load this whenever you will inspect history, commit, split, squash, rebase, reorder, work across multiple branches/PRs, or otherwise touch VCS state.
---

# Jujutsu for Noninteractive Noncorporeal Beings

Jujutsu (`jj`) is a version control system that uses Git for its storage
layer. Most users have their repos **colocated** (the repo root contains both
`.jj/` and `.git/` as siblings). Do **not** take colocation as permission to
run mutable Git commands. **All mutable VCS actions must be run ONLY as `jj`
commands.**

This is not a stylistic preference — it is what lets you, a non-interactive
agent, work fearlessly. Git's mutable commands (`git checkout`, `git reset`,
`git rebase`, `git commit --amend`) can silently destroy uncommitted work
and have no undo. `jj` records every operation and never loses a commit, so a
mistake is a one-line recovery instead of a catastrophe. Mixing the two gives
you the worst of both: see *The colocation footgun* below for how a stray
mutable git command silently clobbers work that lives only in the jj working
copy.

Detect a jj repo by the presence of `.jj/` (e.g. `ls -d .jj`). If it's there, jj
governs all history.

## Why jj for agents

Non-interactive agents can't recover from destructive VCS actions. jj eliminates
the failure modes:

- **Nothing is ever lost.** Every op is reversible. Attempt aggressive history
  surgery without elaborate backups.
- **Mistakes cost one line.** `jj op restore <id>` rewinds entire repo state.
  "Mangled rebase" becomes a non-event.
- **No staging.** Working copy *is* a commit (`@`). Edits auto-snapshot. Never
  `git add`, never half-staged commits.
- **Malleable history.** Do work in one big `@`, test it, *then* shape into
  clean commits. Right structure emerges after work is done.

## Core mental model

- `@` is the working-copy commit. It is a real, editable commit, not a staging
  area. Your uncommitted edits live *in* `@`.
- `@-` is its parent. `jj log` shows the graph; `change_id` (the stable, short
  id like `kwuykwpo`) is what you reference — it survives rewrites, unlike the
  git commit hash which changes every time content does.
- Almost every command rewrites commits and **auto-rebases descendants**
  for you. You move a commit; everything on top follows. Conflicts become
  first-class commit *contents* (a commit can be marked `conflict`) rather than
  a blocking modal state — you can keep working and resolve later.

This doc assumes you already know jj mechanically — it's about *judgment* (which
shapes to build, when, what's yours to do vs. the human's), not a primitives
tutorial. When you hit something you genuinely don't know, **look it up
rather than guess**: `jj help -k <topic>` for concepts (`glossary`, `revsets`,
`filesets`, `templates`, `config`, `bookmarks`, `tutorial`) and `jj <command>
--help` for a command's exact flags and behaviour. The cost of a lookup is
trivial next to the cost of a wrong guess about what a command rewrites.

## Address commits by absolute id, not relative position

**Target commits by their change id, not by relative refs like `@-`, `@--`,
`@-+`, or bare `jj undo`.** Relative references are ergonomic for humans, who
carry an effortless spatial model of where `@` sits and how each command moves
it. You do not have that intuition reliably — and worse, *every* rewrite shifts
what `@-` points at, so a reference that was correct one command ago silently
means something else now. Acting on a stale `@-` is how you abandon or squash
the wrong commit.

The discipline:

- **Read the id, then use the id.** Run `jj log` (or capture the id via a
  template), copy the stable `change_id` (e.g. `kwuykwpo`), and pass *that* to
  `abandon`/`squash`/`rebase`/`describe`/`edit`. Change ids survive rewrites; a
  commit you identified earlier is still reachable by the same id afterward.
- **Prefer explicit revsets and globs over positional ones** when you mean a
  set — `mutable() & description(glob:'wip:*')`, `trunk()..@`, an explicit id
  range — rather than counting parents with `@---`.
- **Re-`jj log` between mutating operations.** Don't carry a remembered graph
  shape across commands that rewrite history; re-read it so the ids you act on
  reflect reality.
- This is also why **`jj op restore <id>` beats `jj undo`** for anything but an
  immediate, single, just-ran mistake: `undo` is relative ("the last op") and
  easy to misjudge after a flurry of commands, whereas an op id you captured up
  front names exactly the state you want back.

When in doubt, spend the cheap `jj log` to ground yourself in real ids rather
than reasoning about positions in your head.

## The squash workflow: overcheckpoint relentlessly

**The single most important habit.** Squashing commits is trivial; un-stitching
is painful surgery. Bias toward overchecking: **`jj new` early and often.** At
each stopping point, change of tack, or before risky work, start fresh:

```
jj new # start a fresh empty @ on top of the current work
```

When finishing work, describe and advance in one motion:

```
jj commit -m "scope: what this change does"
# identical to:  jj describe -m "..." ; jj new
```

**Always land on an empty `@` after completing work.** If you've just shaped
commits (splitting, describing, reordering), the last step is `jj new` to leave
yourself on a clean checkpoint. An agent that finishes work still sitting on the
final described commit is violating the squash workflow — you should be *ahead*
of the finished work, not sitting on it.

**Mark in-flux checkpoints `[wip]`.** Working checkpoint, not finished unit:
`jj describe -m "[wip] scope: ..."`. Makes unfinished work obvious in `jj log`.
Drop `[wip]` when done.

Payoff:
- **Cheap checkpoints** — mistakes only cost work since last `jj new`.
- **Natural boundaries** — `jj new` at each intent change roughly splits along
  conceptual lines. Adjacent commits merge with `jj squash`.
- **No monolithic `@`** — avoids slow, error-prone hand surgery.

When in doubt, `jj new`. Over-checkpointing is free; under-checkpointing is
debt.

## Consolidate mutable commits, don't stack fixups

When you realize a just-made commit needs refinement (typo fix, wrapping,
missed file, better wording), squash the fix back into the source commit with
`jj squash --into <change>` rather than creating a new commit on top. The
source commit is still mutable (unpublished), so the refinement belongs *in* it,
not after it.

Agent failure mode: after creating commit A, immediately realizing it needs a
small fix, then creating commit B "fix A" on top. This creates churn commits.
The right move: make the fix in `@`, then `jj squash --into <A's change id>`.

Applies equally to formatting fixes, typos in commit messages (use `jj describe
<change>`), or "oops, forgot to include this file." If the work is still in your
mutable stack and the fix refines rather than extends, consolidate it backward.

## Review feedback is fixup, almost always

A reviewer asking for a rename, a tighter type signature, a doc-comment
correction, or "use this idiom instead of that one" is not asking for new
conceptual work — they are refining the commit that introduced the line. Squash
the change backward into its source commit with `jj squash --into <change>`
rather than stacking a new "fix the typo" commit on top.

Stacking is easier in the moment; squashing backward tells the truth about which
change owned the line. The reviewer's eventual reading of the stack — and the
project's eventual `git log` / `git blame` — should see one commit per intent,
not a commit per round of feedback. The principle, worth internalising verbatim:
*it is way easier to squash than it is to split.* You are almost always one `jj
squash --into` away from honest history; you are almost never one `jj split`
away from it.

The discipline:

- **Identify the source commit before you start the edit.** `jj log -r 'mine() &
  file(<path>)'` (or `jj annotate <path>`) tells you which commit on your stack
  owns the line you're about to change. Make the edit, then squash it into that
  commit by id.
- **One squash per intent, even within a feedback round.** If the reviewer asks
  for a rename across three commits, do three squashes into three sources, not
  one squash into the topmost commit.
- **Stack a new commit only when the feedback genuinely is new work** — an
  additional test case the reviewer wants, a new code path that didn't exist
  before. That is additive, not fixup.
- **Verify the squashed source commit still builds and passes its own tests.**
  Squashing a fix backward can break the source commit in isolation (e.g. the
  fix references a helper introduced two commits later). The splitting section's
  "verify each intermediate commit builds in isolation" rule applies just as
  much to backward squashes.

The line moves the moment the commit is pushed: published commits cannot be
rewritten without coordination. Before push, squash freely; after push, follow
your team's amend-vs-fixup convention.

## All operations can be restored to and reverted

`jj op log` is a complete, timestamped history of *every* repository operation
(every commit, split, rebase, describe, even working-copy snapshots).

**Before any non-trivial history surgery, capture the current op id** and state
it plainly so you (and the user) have an explicit rollback anchor:

```
jj op log --no-graph --limit 1 -T 'id.short() ++ "  " ++ description ++ "\n"'
```

If anything goes wrong — a botched rebase, a split that landed content in the
wrong commit, an abandon you regret — restore the whole repo to that point:

```
jj op restore <op-id>
```

This is the single most freeing fact about working in jj as an agent: **there
is always a way back.** Use it. If you find yourself reasoning in circles about
whether a sequence of rewrites is safe, just note the op id and try it — you can
always `jj op restore`.

## No commits are EVER lost

`jj abandon` does not delete content irrecoverably; the commit remains reachable
by its commit hash and via the op log. If you abandon a commit and later need
its content, you can recover it (e.g. `jj --at-op <op> log -r <change>` to find
it, or `jj op restore` to bring back the whole state). This is why it's safe to
abandon scratch/intermediate commits aggressively while shaping history — you
are never burning a bridge.

Corollary: prefer `jj abandon` + rebuild over trying to surgically un-pick a
tangled commit when the rebuild is clearer. The abandoned version is still there
if your rebuild goes wrong.

## Resolving conflicts

In jj a conflict is not a blocking modal state — it's recorded *as the content
of a commit* (the commit is marked `conflict`, and conflicted files carry
conflict markers). That means you don't have to resolve a conflict the instant
a rebase/squash creates it; you can locate conflicted commits any time with the
`conflicts()` revset and fix them deliberately. The idiomatic, agent-safe loop:

```
jj new <conflicted-change>   # a fresh child of the conflicted commit (use its id)
jj resolve --list            # enumerate which files are conflicted
# ...edit the conflict markers in those files directly, per the intended
#    semantics of the changes being merged...
jj show --git                # review your resolution as a diff before committing it
jj squash                    # fold the resolution down into the conflicted parent
# repeat until `jj log` shows no commit marked `conflict`
```

Why this shape:

- **Resolve in a child, then `jj squash` down.** Squashing the resolution into
  the conflicted parent makes the fix *propagate* — descendants auto-rebase onto
  the now-resolved commit, so conflicts that were inherited downstream clear up
  as you work from the bottom. Resolve the lowest conflicted commit first.
- **Edit the markers directly; do not run bare `jj resolve`.** Plain `jj
  resolve` launches an *interactive* external merge tool, which will hang a
  non-interactive agent. Use `jj resolve --list` only to *find* the conflicted
  files, then edit their markers with your normal file tools. (The conflict
  markers are ordinary text in the file.)
- **Resolve by intent, not by mechanically picking a side.** A conflict means
  two changes touched the same place; read both and reconstruct what the
  combined result *should* be, exactly as you would for any merge — don't just
  keep one side to make the markers go away.
- **`jj show --git` before you squash** to confirm the resolution is what you
  meant, and lean on the absolute-id and checkpoint disciplines above: target
  the conflicted commit by id, and you've got `jj op restore` if a resolution
  goes wrong.

## Interdiff is your friend for making clean history

When you rewrite history — especially splitting one big commit into several —
you need to *prove* you didn't change the actual code, only its arrangement. The
**interdiff** is the proof: diff the final tree of your rewritten stack against
the tree of the original pre-rewrite commit. If it's empty, the rewrite is
content-identical and you're done.

```
# original-top = the commit (hash or change id) that bundled everything,
# rebuilt-top  = the topmost commit of your new split stack
jj diff --from <original-top> --to <rebuilt-top> --stat
# "0 files changed" == a provably faithful rewrite, zero drift
```

If the original commit was already abandoned during the split, recover its hash
from the op log: `jj --at-op <op-id> log -r <change> --no-graph -T 'commit_id'`,
then interdiff against that hash. Most of the time it reports zero drift and
tells you nothing new — but that's exactly the point: it *converts hope into
proof*, cheaply, so a confident rewrite is a verified one.

## Splitting one big change into clean logical commits

This section is the *cure* for an under-checkpointed `@`. The *prevention* is
the squash workflow above — `jj new` at each change of intent and you rarely
end up here. But when you do inherit (or create) one big commit, this is how you
shape it. You did the work in one `@`; now shape it.

**1. File-granular skeleton with `jj split` (non-interactive).** Get the
direction right, because it's the opposite of the intuition and it *will* bite
you: `jj split <files>` **leaves the selected files behind in the parent (first)
commit and moves everything else up into the child.** You are choosing what to
*peel off below*, not what to lift onto a new commit. So to isolate one concern,
split out the files for the concern you want *earliest* in the stack; iterate,
and the remainder keeps floating to the top.

```
jj split <fileset> ... # those files stay in the parent; the rest goes to the child @
```

Because the selected files are what stays *below*, the fileset operators are
your friends — don't enumerate "all the files I want to move up." Invert with
negation instead: `jj split ~path/to/keep-on-top.rs` leaves everything *except*
that file in the parent and floats it up into the child. Likewise `~glob:...`
or `a | b` to express "everything but these" in one expression. Reach for the
fileset language (`jj help -k filesets`) rather than hand-listing files.

**2. Beat the interactive editor.** Several commands (`jj split`, `jj
describe` without `-m`, `jj squash -i`) open `$EDITOR`, which hangs/aborts in a
non-interactive shell. Two fixes:

- Pass `-m "message"` whenever the command supports it (`jj describe -m`, `jj
  commit -m`, `jj split -m` for the first part).
- For commands that still want to edit a description you'll set later,
  neutralize the editor: `JJ_EDITOR=true jj split <fileset>` (the `true` binary
  exits 0 without editing). Then set descriptions afterward with `jj describe
  <change> -m`.

**3. Within-file content separation (the new/edit/squash technique).**
File-level splits can't separate two concepts that live in the *same* file (e.g.
a shared `mod.rs` touched by two features). When you need that granularity,
don't try to move hunks — **reconstruct the intermediate file states** and build
the commits up in order:

- Save the final version of each entangled file, and a clean base version (`jj
  file show -r <base> <path>` — but verify line counts; redirecting its output
  to the *same file you're reading from* will truncate it, so write to a temp
  path).
- For each concept commit in order: `jj new -m "..."` on the right parent, write
  the working files to that concept's intermediate state, verify it compiles,
  and the changes land in that commit. Squash/abandon scratch as needed.
- If two concepts share a file and a later commit fully supersedes an earlier
  one's version of it, you can just write the *final* file in the later commit —
  jj shows only the delta vs the now-already-committed earlier version.
- **Verify each intermediate commit builds in isolation** (`jj new <change>` →
  build) — the classic hazard of a manual split is an intermediate commit that
  doesn't compile.
- **Interdiff at the end** to prove zero drift (above).

**4. Set descriptions by change id, reorder freely.**

```
jj describe <change> -m "scope: imperative summary

Body explaining the why."
jj rebase -r <change> -d <new-parent>     # move a commit (e.g. docs to the top)
```

Match the repo's existing commit style (inspect `jj log` first).

## Megamerges for noncorporeal beings

You know that a merge commit is just an ordinary commit with multiple parents,
and that nothing stops it having three or more (an *octopus merge*). A
**megamerge** weaponizes that: an octopus merge whose parents are *every stream
you care about at once*, with an empty `@` on top where you actually work.
Working in that `@` means you're always sitting on the combined sum of all those
streams — so if `@` builds and runs, you know the streams interoperate. This is
the shape that lets an operator (or you) juggle many parallel efforts without
context-switching through the VCS.

### Recognizing one

In `jj log` it's a node with several parents converging (`├─┬─╮`), usually
described "megamerge", with `@` (often empty) directly above it. When you see
that, you're in the megamerge workflow — follow the conventions below.

**A megamerge is structurally never a thing to publish** — only the branches
it composes ever get published, and even those only by a human (see *Never
push*). The merge node itself is a private working convenience; it has no
business on any remote.

### First-order vs. second-order

- **FOMM (first-order)** — human's structural object. Parents are publishable
  streams (feature branches, PRs, others' work). Theirs to own.
- **SOMM (second-order)** — yours to build, stacked on FOMM. Parents are your
  own WIP streams. Multiple independent threads staying reviewable while proving
  interoperability. Label tips `[wip] scope: …`.

Tell apart by parents: FOMM has publishable/tracked branches; SOMM has your
mutable WIP. SOMM is merge closest to `@`.

### Operating inside one

- Do your work in the empty `@` on top, as normal.
- Place finished changes into the right downstream commit **deliberately**,
  with `jj squash --into <change>` (or `--interactive` to pick exact hunks). You
  have the patience and precision to put each change exactly where it belongs
  — **don't reach for `jj absorb`**, which auto-scatters hunks for humans in a
  hurry; intentional placement is more correct and more reviewable.
- Building a SOMM out of your own WIP is fine to do autonomously — it's
  organizing *your* unpublished work, not touching anything publishable.

### What's yours vs. the human's: the `closest_merge(@)` rule

The `stack` and `stage` aliases operate on **`closest_merge(@)`** — the nearest
merge below `@` — inserting/staging work between `trunk()` and that merge. Which
merge that is decides whether the action is yours to take:

- **No SOMM in play → `closest_merge(@)` is the FOMM.** Do **not** run
  `stack`/`stage` unprompted: that shuffles *publishable*-stream lifecycle, a
  low-effort rubber-stamp the operator prefers to do themselves. Surface the
  need and ask.
- **You built a SOMM → `closest_merge(@)` is the SOMM.** Now `stack`/`stage`
  only reorganize *your own unpublished* WIP, so running them is fine.
- **`restack`** rebases the mutable publishable streams onto `trunk()` — syncing
  with the outside world. **Always defer that to the human**, SOMM or not.
- Promoting your WIP up *out of* the SOMM and *into* the FOMM is a deliberate,
  publishable-lifecycle step — treat it as the human's to approve.

These aliases are assumed present in the environment (the operator's config
replicates them everywhere); if one isn't, or you're unsure what it expands to,
check with `jj config list` / `jj help` rather than guessing.

## The colocation footgun

In a colocated repo it is tempting to reach for a familiar Git command. **Do
not.** The trap, concretely:

- `git checkout <file>` to discard an edit reverts the file to the last **git**
  commit — which is typically *behind* the jj working copy, because jj's
  `@`   holds uncommitted work git doesn't know about. The result is silent:
  it   clobbers correct work that lived only in `@`. And because no jj operation
  recorded the git mutation, the `jj op restore` safety net doesn't cover it
  cleanly — the lost work has to be rebuilt by hand. The same hazard applies to
  every mutating git command (`reset`, `restore`, `rebase`, `commit`, `stash`).

The discipline that prevents this:

- **Read-only git is fine** (`git log`, `git diff`, `gh ...` for GitHub).
  Mutating git commands (`checkout`, `reset`, `restore`, `rebase`, `commit`,
  `add`, `stash`) are **forbidden** — there is always a jj equivalent.
- To discard a working-copy change: `jj restore <path>` (from the parent) —
  never `git checkout`.
- To undo a jj operation: `jj op restore <id>` (the id you captured up front) —
  never `git reset`. `jj undo` is fine only for an immediate, just-ran mistake.
- To set identity / configure: jj has its own (`jj config`), and identity is
  usually already set; never touch git config.

## Never push

**Do not push — ever — on your own initiative.** No `jj git push`, no `git
push`, no creating or moving remote bookmarks. Publishing is a human-owned
action: it exposes work to other people, CI, and review, and is not yours to
trigger.

If a human explicitly asks you to push, **confirm before doing it, every time**
— restate exactly what will be published (which bookmarks, to which remote) and
wait for a clear go-ahead. Treat permission as scoped to that one push, not as a
standing grant. Two failure modes make this strict rule worth it:

- Agents routinely forget that "yes, push" was permission to push *once*, and
  later push again unprompted as if the door were left open.
- Over-correcting the other way, agents also re-ask for things they were
  already, durably allowed to do. The clean line: **mutating the remote always
  needs a fresh confirmation; local history operations do not.**

Everything this document teaches — checkpointing, splitting, rebasing,
megamerges — is *local* and safe to do autonomously precisely because none of it
touches the remote. The remote is the one boundary you don't cross alone.

## Quick reference (the agent-specific bits, not a command tutorial)

You know the commands; these are the entries that carry a *gotcha* or an agent
*rule* worth not relearning the hard way. For anything else, `jj help`.

| Situation                       | What to actually do                                                                                                            |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| About to do history surgery     | Capture an anchor first: `jj op log --no-graph --limit 1 -T 'id.short()'`                                                      |
| It went wrong                   | `jj op restore <id>` (captured anchor); `jj undo` only for the just-ran op                                                     |
| Targeting a commit              | Use its `change_id` from `jj log`, never `@-`/`@--` positional refs                                                            |
| Checkpoint cadence              | `jj new` early and often; `jj commit -m "..."` to finish-and-advance                                                           |
| Just finished shaping commits   | `jj new` to land on empty `@` ahead of the work — don't sit on the final commit                                                |
| Just-made commit needs a fix    | `jj squash --into <change>` to consolidate; don't stack "fix commit A" on top                                                  |
| In-flux checkpoint              | Prefix the description `[wip] scope: …` so the live work is obvious                                                            |
| Peeling files off a commit      | `jj split <fileset>` leaves them in the *parent*; use `~` to invert                                                            |
| Discard working-copy edits      | `jj restore <path>` — **never** `git checkout`                                                                                 |
| Read a file at another revision | `jj file show -r <change> <path>` — write output to a TEMP path, not the live file                                             |
| Prove a rewrite changed nothing | `jj diff --from <orig> --to <new> --stat` → want "0 files"                                                                     |
| Resolving a conflict            | `jj new <conflicted-id>` → edit markers (`jj resolve --list` to find them, never bare `jj resolve`) → `jj squash` down; repeat |
| In a megamerge, placing work    | `jj squash --into <change>` (deliberate); not `jj absorb`                                                                      |
| `stack`/`stage`/`restack`       | Governed by the `closest_merge(@)` rule above, not a one-liner                                                                 |
| Asked to push                   | Confirm first, every time; permission is per-push, never standing                                                              |

Two habits carry almost everything else: **`jj new` early and often** so clean
commit boundaries fall out for free and a mistake is cheap, and **note the op
id, try the thing, and `jj op restore` if it's wrong.** Together — frequent
checkpoints plus a perfect undo — they are what let you spend your context on
the actual problem instead of VCS churn.
