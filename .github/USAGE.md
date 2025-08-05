# Quick Start Guide - GitHub Action for Next Steps

This guide shows how to use the "Generate Next Steps Issues" GitHub Action.

## How It Works

The action reads the `AGENT-ZERO-GENESIS.md` file and automatically creates GitHub issues for each uncompleted task in the "Next Development Steps" section.

## First Time Setup

1. **Go to Actions Tab**: Visit your repository on GitHub and click the "Actions" tab
2. **Find the Workflow**: Look for "Generate Next Steps Issues" in the workflow list
3. **Run Manually**: Click "Run workflow" to generate issues for the first time
4. **Check Results**: Go to the "Issues" tab to see the generated issues

## What Gets Created

For each uncompleted task (marked with `- [ ]`), an issue is created with:

- **Title**: `[Timeline] Task Description`
- **Labels**: `next-steps`, `roadmap`, and timeline-specific label
- **Body**: Detailed description with context and acceptance criteria

Example issue:
```
Title: [Immediate (Week 1-2)] Package OpenCog for Guix
Labels: next-steps, roadmap, immediate-week-1-2
```

## Marking Tasks as Complete

When you complete a task:

1. **Edit the roadmap**: Change `- [ ]` to `- [x]` in `AGENT-ZERO-GENESIS.md`
2. **Close the issue**: Manually close the corresponding GitHub issue
3. **Commit changes**: Push your roadmap updates

Example:
```markdown
## Next Development Steps

1. **Immediate (Week 1-2)**:
   - [x] Package OpenCog for Guix          ← Completed
   - [ ] Package GGML for Guix             ← Still pending
   - [ ] Create basic cognitive kernel module
   - [ ] Implement tensor field encoding
```

## Automatic Runs

The workflow runs automatically every Monday at 9 AM UTC to check for:
- New tasks added to the roadmap
- Tasks that were unmarked (changed from completed back to pending)

## Manual Options

**Force Recreate**: Use this option to:
- Close all existing next-steps issues
- Recreate issues for all uncompleted tasks
- Useful for major roadmap reorganization

## Viewing Issues

- **All next-steps issues**: [Issues with next-steps label](../../issues?q=is%3Aissue+label%3Anext-steps)
- **By timeline**: Filter by timeline labels like `immediate-week-1-2`
- **Tracking issue**: Shows generation statistics and summary

## Current Roadmap Status

As of the last run, the roadmap contains:
- **4 timeline sections** (Immediate, Short-term, Medium-term, Long-term)  
- **16 total tasks** to be implemented
- **0 completed tasks** (all are currently pending)

This will automatically create 16 GitHub issues to track development progress.