;; highlight string as query if starts with `;; query`
((string ("string_content") @query) (#lua-match? @query "^%s*;+%s?query"))

