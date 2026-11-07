# Humanizer pass (adapted from blader/humanizer, MIT, based on Wikipedia "Signs of AI writing")

Vale already flags the word level tells (MyRules.AITells, AIInflation, ChatbotResidue, BorrowedAuthority, ContrastTic). This list is for the ones a regex can't see. Read the text once against it. Cut only the tell; keep the writer's facts, slang, specifics and hedges.

## Check every time
1. Not X but Y: "it's not just X, it's Y", "this doesn't mean X, it means Y". State the point.
2. Dramatic closers and fragments: a one line ending that repeats the point, "No prior. No nostalgia." Cut or merge into a real claim.
3. Sayings that sound deep: "at its core, what matters is". Replace with the specific claim.
4. Staged run up: "let's dive in", "Honestly? It depends". Start at the point.
5. Arguing with no one: answering an objection nobody raised, "a tempting approach would be". Cut.
6. Forced threes: three adjectives or three examples because three sounds right. Use the number the meaning needs.
7. Same sentence openings: "I... I... I..." or "She noted... She noted...". Merge or change the subject.
12. AI words: delve, testament, landscape, showcasing, tapestry. Plain words.
13. Inflated significance: "a pivotal moment", "the future looks bright". Keep the fact, end on the last concrete fact.
14. Vague connection: "associated with", "in connection with". Say the real relationship.
15. Shallow -ing riders: ", reflecting his commitment to...". Cut unless the source supports it.
16. Sales language: "nestled", "breathtaking", "seamless", "cutting edge". Say what it is.
17. Borrowed authority: "experts believe", a list of outlets. Name a real source or cut.
18. Avoiding is/has: "serves as", "boasts", "features". Use is/has.
22. Chatbot residue: "Great question!", "I hope this helps!". Cut the wrapper.
23. Knowledge limit hedges: "while details are limited, it appears". Say what is known or cut.
26. Re-explaining what the reader knows: walking through background before the ask. Lead with the ask.

## Long form only (essays, app copy, docs), skip for texts and short emails
19. Bold as decoration. 20. Title Case or emoji headings. 24. Heading repeated in the first sentence. 25. Writing about the document ("the table below shows") instead of the subject.

## Overridden by these rules, do not apply
8. Dashes: already a hard rule (zero dashes), stricter than Humanizer.
9. Stacked qualifiers: hedges stay visible. Only cut a qualifier that is clearly doubled ("could potentially possibly").
10. Hyphenated pairs: skip.
11. Passive voice: off on purpose.
21. Curly quotes: phones curl them; ignore.

## Guardrail
A full Humanizer rewrite once cut a 70 word outreach to 30 words and flattened it. So fix tells with the fewest changes. A casual text to a friend stays casual. Never add polish the writer did not have.
