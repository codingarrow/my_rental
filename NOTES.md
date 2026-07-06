# NOTES

1. One fix explained (Task 2 — the PHP 0 bug)
`rental_days` used `(to_date - from_date).days`, which is an *exclusive*
day count: a same-day rental (from == to) came out as 0 days, so the total
was `rate * 0 = PHP 0.00`, and every short rental was undercharged by one day.
Billing is inclusive (both start and end day count), so the fix is simply
`(to_date - from_date).days + 1`. Now a same-day rental is 1 day and a
Jan 10–15 rental is 6 days.

2. The failure (Task 1 — double booking)
Existing booking: Canon DSLR Camera, 2026-01-10 to 2026-01-15.
The old `dates_overlap` (which only checked `start_b <= start_a <= end_b`)
**wrongly allowed** a new booking of **2026-01-08 to 2026-01-12** — it starts
before the existing range so its start isn't "inside", yet it clearly overlaps.
The corrected test `start_a <= end_b and start_b <= end_a` now correctly
blocks it (409 conflict).

3. Others
to sanity-check the standard interval-overlap formula
and to draft the Podman/Dockerfile boilerplate. I verified the overlap fix by
hand-tracing four cases against the seeded Jan 10–15 booking:
before-overlap (Jan 8–12), inside (Jan 11–13), after-overlap (Jan 14–20), and
fully-clear (Jan 20–22) — the first three now conflict, the last is allowed.
I verified the day-count fix by checking same-day = 1 day and Jan 10–15 = 6 days.
I did not accept any AI output without running it against these concrete dates.

