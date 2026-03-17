# Skill Quality Checklist

## Structure Validation

- [ ] Folder named in kebab-case (no spaces, no capitals, no underscores)
- [ ] File named exactly `SKILL.md` (case-sensitive)
- [ ] YAML frontmatter has `---` delimiters (opening and closing)
- [ ] No README.md inside skill folder (all docs go in SKILL.md or references/)

## Frontmatter Validation

- [ ] `name` field: kebab-case, matches folder name
- [ ] `description` field present and includes:
  - What the skill does
  - When to use it (trigger phrases users would actually say)
- [ ] `description` under 1024 characters
- [ ] No XML angle brackets (< >) anywhere in frontmatter
- [ ] No "claude" or "anthropic" in name field

## Instructions Quality

- [ ] Instructions use bullet points and numbered lists (not walls of text)
- [ ] Critical instructions at TOP with `##` headers
- [ ] Each step is specific and actionable (not "validate the data")
- [ ] Steps include expected output (what success looks like)
- [ ] Error handling section with common failure modes
- [ ] Examples with trigger phrases and expected results

## Progressive Disclosure

- [ ] SKILL.md under 5000 words
- [ ] Detailed docs moved to `references/` and linked
- [ ] Reference files mentioned where relevant in SKILL.md

## Triggering Quality

- [ ] Description includes 2-3 trigger phrases users would say
- [ ] Negative triggers added if scope is narrow ("Do NOT use for...")
- [ ] Not too generic ("Helps with projects" won't work)
- [ ] Not too technical ("Implements entity model" won't trigger)

## Testing

- [ ] Tested triggering on obvious tasks
- [ ] Tested triggering on paraphrased requests
- [ ] Verified doesn't trigger on unrelated topics
- [ ] Functional tests pass (workflow produces correct output)
