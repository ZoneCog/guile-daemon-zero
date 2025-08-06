# GitHub Actions for Agent-Zero Genesis

This directory contains GitHub Actions workflows for the Agent-Zero Genesis project.

## Workflows

### Generate Next Steps Issues

**File:** `workflows/generate-next-steps.yml`

Automatically creates GitHub issues from the development roadmap defined in `AGENT-ZERO-GENESIS.md`.

#### Features

- **Automatic Parsing**: Reads the "Next Development Steps" section from the roadmap
- **Smart Issue Creation**: Only creates issues for uncompleted tasks (empty checkboxes)
- **Duplicate Prevention**: Avoids creating duplicate issues by checking existing ones
- **Proper Labeling**: Assigns appropriate labels based on timeline (immediate, short-term, etc.)
- **Tracking**: Creates a tracking issue for manual runs with generation summary

#### Triggers

1. **Manual Trigger** (`workflow_dispatch`):
   - Can be run manually from the Actions tab
   - Option to force recreate all issues (closes existing ones first)

2. **Scheduled Trigger** (`schedule`):
   - Runs weekly on Mondays at 9 AM UTC
   - Automatically checks for new uncompleted tasks

#### Labels Applied

- `next-steps`: All generated issues get this label for easy filtering
- `roadmap`: Indicates the issue was automatically generated from roadmap
- Timeline-specific labels:
  - `immediate-week-1-2`: For immediate priority tasks
  - `short-term-month-1`: For short-term tasks
  - `medium-term-month-2-3`: For medium-term tasks  
  - `long-term-month-3+`: For long-term tasks

#### Issue Format

Generated issues follow this structure:

```
Title: [Timeline] Task Description

Body:
## Timeline: Immediate (Week 1-2)

This task is part of the Agent-Zero Genesis development roadmap.

### Task Description
Package OpenCog for Guix

### Context
This is a immediate (week 1-2) priority task from the Agent-Zero Genesis roadmap.

### Acceptance Criteria
- [ ] Task implementation completed
- [ ] Code tested and validated
- [ ] Documentation updated if needed
- [ ] Update roadmap checkbox when complete
```

#### Usage

**Manual Run:**
1. Go to Actions tab in GitHub
2. Select "Generate Next Steps Issues" workflow
3. Click "Run workflow"
4. Optionally check "Force recreate all issues" to refresh everything

**View Generated Issues:**
- All: https://github.com/ZoneCog/guile-daemon-zero/issues?q=is%3Aissue+label%3Anext-steps
- By timeline: Add additional label filter (e.g., `label:immediate-week-1-2`)

#### Updating the Roadmap

When tasks are completed:

1. Edit `AGENT-ZERO-GENESIS.md`
2. Change `- [ ]` to `- [x]` for completed tasks
3. Commit the changes
4. Manually close the corresponding GitHub issue
5. The next workflow run will skip creating issues for completed tasks

#### Permissions Required

The workflow needs these permissions:
- `issues: write` - To create and manage issues
- `contents: read` - To read the roadmap file

These are automatically provided when running in the repository context.