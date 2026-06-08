---
name: auto-tagger
description: "Automatically analyze and add relevant tags to all vault notes. Triggers: 'add tags', 'tag notes', 'auto-tag', '自动添加tags', '为笔记添加标签', 'tag all notes'"
triggers:
  - "add tags"
  - "tag notes"
  - "auto-tag"
  - "自动添加tags"
  - "为笔记添加标签"
  - "tag all notes"
  - "add tags to all notes"
---

# Auto-Tagger Skill

Automatically analyze note content and add relevant, consistent tags across the vault.

## Workflow

### Step 1: Identify target notes

Use `list_files` to get all .md files. Filter by:
- Include files in content folders (e.g., `Miscellany/`, `Projects/`, `Notes/`)
- Exclude system files (`Welcome.md`, `.obsidian/`, `data/`, `.vault-operator/`)
- Exclude `assets/` subdirectories

### Step 2: Check existing tags

For each note, use `get_frontmatter` to check if it already has meaningful tags.
- If `tags` is `null`, empty, or only contains `["ToRead"]`, the note needs tagging
- If it already has 3+ topic-specific tags, skip it

### Step 3: Analyze content and determine tags

For each note that needs tags:

1. **Read the note** using `read_file` (focus on title, description, and first ~500 chars of body)
2. **Determine tags** based on:
   - **Title keywords** → primary subject tags
   - **Source domain** → category hints (e.g., IEEE → academic, GitHub → code)
   - **Description** → specific topic tags
   - **Content themes** → additional context tags

3. **Tag naming conventions**:
   - Lowercase, hyphenated: `machine-learning`, not `Machine Learning`
   - Singular preferred: `compiler`, not `compilers`
   - Use established categories:
     - **Technology**: `hardware`, `software`, `networking`, `security`, `databases`
     - **AI/ML**: `ai`, `machine-learning`, `llm`, `deep-learning`, `neuroscience`
     - **Programming**: `programming-languages`, `compilers`, `devops`, `systems`
     - **Science**: `physics`, `biology`, `genetics`, `mathematics`
     - **Culture**: `books`, `history`, `open-source`, `ethics`
     - **Hardware**: `sbc`, `gpu`, `cpu`, `memory`, `fpga`
     - **Networking**: `dns`, `tcp`, `bbs`, `retro-computing`
     - **Creative**: `music`, `synthesizer`, `audio`, `creative-coding`
     - **Life**: `health`, `supplements`, `leadership`, `management`

4. **Preserve existing tags**: Always keep existing tags (especially `ToRead`) and ADD new ones

### Step 4: Apply tags

Use `update_frontmatter` to set tags. Example:
```
update_frontmatter(path, { tags: ["ToRead", "new-tag-1", "new-tag-2"] })
```

### Step 5: Batch processing rules

- Process notes in parallel batches of 5-6 when possible
- Use `update_todo_list` to track progress for 10+ notes
- After completion, provide a summary of all tags added

## Tag Quality Guidelines

- **Specificity**: Prefer specific tags over generic ones (`genetics` > `biology`)
- **Consistency**: Reuse existing vault tags when possible (check `get_vault_stats`)
- **Quantity**: Aim for 3-6 tags per note (not too few, not too many)
- **Hierarchy**: Include both broad category and specific topic
- **No duplicates**: Never add a tag that's already present

## Example Tag Mapping

| Note Content | Suggested Tags |
|-------------|----------------|
| AI model release | `ai`, `machine-learning`, `llm`, `open-source` |
| Hardware review | `hardware`, `[device-type]`, `review` |
| Programming tutorial | `programming`, `[language]`, `tutorial` |
| Scientific paper | `[field]`, `scientific-research`, `academic` |
| Security advisory | `security`, `[technology]`, `vulnerability` |
| History article | `history`, `[topic]`, `[era]` |
