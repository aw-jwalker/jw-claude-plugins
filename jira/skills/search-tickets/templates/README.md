# Search Templates

Reusable keyword templates organized by topic area. Each JSON file
contains keyword combinations that have proven effective for a
particular domain.

## Structure

```json
{
  "topic": "description of the topic",
  "base_keywords": ["core", "terms"],
  "synonym_groups": [
    ["term1a", "term1b", "term1c"],
    ["term2a", "term2b"]
  ],
  "effective_combos": [
    {
      "query": "the actual search string",
      "what_it_finds": "description of what this tends to surface"
    }
  ],
  "technical_terms": ["DB_Table_Name", "FileName.ts"],
  "project": "IWA"
}
```

## Usage

When searching a new topic, check if a template exists here first.
If so, use its keyword combos as a starting point and adapt.
