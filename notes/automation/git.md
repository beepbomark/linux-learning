# Git

Source: CompTIA Linux+ XK0-006, objective 4.4

## .gitignore
### What it is 
A file used by Git to specify which files and directories should be ignored and not tracked in the repository
### Purpose
- Prevent unnecessary files from being committed
- Exclude temporary, generated, or sensitive files
- Keep repository clean and organized
- Avoid tracking environment-specific artifacts
### Common files to ignore
- Log files -> `*.log`
- Temporary files -> `*.tmp`, `*.swp`
- Build artifacts -> `build/`, `dist/`
- Dependency folders -> `node_modules/`
- Python virtual environments -> `venv/`, `.venv/`
- Compiled files -> `*.pyc`, `*.o`
- Secrets/configs -> `.env`, `*.key`
### Basic syntax
```bash
# ignore log files
*.log

# ignore directory
temp/

# ignore specific file
secret.txt
```
### Common patterns
#### Ignore by extension
```bash
*.log
*.tmp
*.pyc
```
#### Ignore directories
```bash
node_modules/
build/
dist/
venv/
```
#### Ignore specific files
```bash
.env
config.local
secret.key
```
#### Negation rule
- `!` means do not ignore a matching file
```bash
*.log
!important.log
```
## add
### What it is
A Git command used to stage changes (new, modified, or deleted files) in preparation for committing them to the repository.
### Purpose
- Move changes from working directory -> staging area
- Select specific files or changes to commit
- Control what gets included in a commit
### Basic syntax
```bash
git add file_name
```
### Common usage
#### Add a single file
```bash
git add script.sh
```
#### Add multiple files
```bash
git add file1.txt file2.txt
```
#### Add all changes (including deletions)
```bash
git add -A
```
#### Add only modified/deleted files (not new files)
```bash
git add -u
```
### Staging concept
- Working directory -> where files are edited
- Staging area -> selected changes ready for commit
- Repository -> committed history
### Interactive staging
```bash
git add -p
```
- Allow staging parts of a file (hunks)
- Useful for precise commits
### Checking staged changes
```bash
git status
git diff --staged
```
### Unstaging changes
```bash
git restore --staged file_name
```
### Tools
```bash
# stage everything
git add .

# check status
git status

# commit after staging
git commit -m "message"
```
### Best practices
- Stage only relevant changes (avoid `git add .` blindly)
- Use meaningful commit grouping
- Review changes before committing
- Use interactive mode for better control
### Notes
- `git add` does not commit changes -> only stages them
- Files must be staged before they can be committed
- Changes can be staged incrementally
- `.gitignore` affects which files can be added
### Common pitfalls
- Accidentally staging unwanted files (`git add .`)
- Forgetting to stage changes before commit
- Not reviewing staged changes
- Assuming `git add` automatically commits
### Real-world scenario
1. Developer modifies several files
2. Uses `git add` to stage only relevant changes
3. Reviews staged changes using `git status`
4. Commits changes with meaningful messages
5. Maintains clean and organized commit history
---
## branch
### What it is
A Git feature that allows you to create separate lines of development, enabling work on features, fixes, or experiments without affecting the main codebase.
### Purpose
- Isolate development work
- Enable parallel development
- Prevent breaking the main branch
- Support collaboration and version control workflows
### Key concepts
- Branch -> independent line of commits
- Main branch -> usually `main` or `master` (stable code)
- Feature branch -> used for new features or changes
- HEAD -> pointer to current branch
### Basic syntax
```bash
git branch
```
### Create branch
```bash
git branch feature-login
```
### Switch branch
```bash
git checkout feature-login
```
### Modern command
```bash
git switch feature-login
```
### Create and switch
```bash
git checkout -b feature-login
# or
git switch -c feature-login
```
### Delete branch
```bash
git branch -d feature-login
```
### View branches
```bash
git branch
git branch -a
```
### Merge branch
```bash
git checkout main
git merge feature-login
```
### Rename branch
```bash
git branch -m old-name new-name
```
### Tools
```bash
# show current branch
git branch --show-current

# show branch history
git log --oneline --graph --all
```
### Workflow example
1. Create feature branch
2. Make changes and commits
3. Switch back to main branch
4. Merge feature branch
5. Delete branch after merge
### Best practices
- Use descriptive branch names (e.g., `feature/login`, `bugfix/api-error`)
- Keep branches short-lived
- Regularly sync with main branch
- Avoid working directly on main branch
- Delete merged branches to keep repo clean
### Notes
- Branching is lightweight in Git
- Changes in one branch do not affect others until merged
- Multiple branches can exist simultaneously
- Essential for collaborative development
### Common pitfalls
- Forgetting to switch branches before making changes
- Merge conflicts when branches diverge
- Leaving stale branches unused
- Accidentally committing to main branch
### Real-world scenario
1. Developer creates a branch for a new feature
2. Works independently without affecting main branch
3. Tests and commits changes
4. Merges branch into main after review
5. Deletes branch to keep repository organized
---
## checkout
### What it is
Switch between branches or restore files from a specific commit.
### Purpose 
- Move between branches
- Restore file versions
### Tools
```bash
git checkout branch_name
git checkout -b new_branch
git checkout file.txt
```
### Notes
- Older command (replaced by `git switch` / `git restore`)
- Can modify working directory state
---
## clone
### What it is
Creates a local copy of a remote repository.
### Purpose
- Download project from remote source
### Tools
```bash
git clone https://repo-url.git
```
### Notes
- Includes full history
- Sets up remote origin automatically
---
## commit
### What it is
Saves staged changes into repository history.
### Purpose
- Record changes with a message
### Tools
```bash
git commit -m "message"
git commit -am "message"
```
### Notes
- Only staged changes are committed
- Commit messages should be meaningful
---
## config
### What it is
Sets Git configuration options.
### Purpose
- Define user identity and preferences
### Tools
```bash
git config --global user.name "Name"
git config --global user.email "email@example.com"
git config --list
```
### Notes
- Can be system, global, or local level
---
## diff
### What it is
Show differences between files or commits
### Purpose
- Review changes before committing
### Tools
```bash
git diff
git diff --staged
git diff commit1 commit2
```
### Notes
- Helps prevent mistakes before commit
---
## fetch
### What it is
Download changes from remote repository without merging.
### Purpose
- Update local repo info safely
### Tools
```bash
git fetch origin
```
### Notes
- DOes not modify working directory
- Used before merge/rebase
---
## init
### What it is
Initializes a new Git repository
### Purpose
- Start version control in a project
### Tools
```bash
git init
```
### Notes
- Creates `.git/` directory
---
## log
### What it is
- Displays commit history
### Purpose
- Review project changes
### Tools
```bash
git log
git log --oneline
git log --graph
```
### Notes
- Useful for debugging and tracking
---
## merge
### What it is
Combines changes from one branch into another.
### Purpose
- Integrate feature branches
### Tools
```bash
git checkout main
git merge feature-branch
```
### Notes
- May cause merge conflicts
- Preserves history
---
## pull
### What it is
Fetch + merge from remote repository
### Purpose
- Update local branch with remote changes
### Tools
```bash
git pull origin main
```
### Notes
- Combines fetch and merge
- Can cause conflicts
---
## push
### What it is
Uploads local commits to remote repository.
### Purpose
- Share changes with others
### Tools
```bash
git push origin main
```
### Notes
- Requires permissions
- May require pull first
---
## rebase
### What it is
Reapplies commits on top of another branch.
### Purpose
- Create clean, linear history
### Tools
```bash
git rebase main
```
### Notes 
- Rewrites history (use carefully)
- Avoid on shared branches
---
## reset
### What it is
Moves HEAD and optionally modifies staging/working directory.
### Purpose
- Undo commits or changes
### Tools
```bash
git reset --soft HEAD~1
git reset --hard HEAD~1
```
### Notes
- `--soft` -> keep changes staged
- `--hard` -> deletes changes
---
## stash
### What it is
Temporarily saves uncommitted changes.
### Purpose
- Switch context without committing
### Tools
```bash
git stash
git stash pop
git stash list
```
### Notes
- Useful for quick context switching
---
## tag
### What it is
Marks a specific commit (e.g., release version).
### Purpose
- Versioning and releases
### Tools
```bash
git tag v1.0
git tag -a v1.0 -m "release"
git push origin v1.0
```
### Notes
- Tags are often used for releases
- Can be lightweight or annotated
---
