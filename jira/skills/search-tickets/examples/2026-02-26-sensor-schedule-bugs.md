# 2026-02-26 - Sensor/Receiver Schedule & Assignment Bugs

## Context

User wanted a comprehensive list of open bug/task tickets related to
sensors (receivers) and their schedules. Topics included: Add/Edit MP
modal, swapping sensors, replacing sensors, missing/wrong schedules,
sensors assigned to two facilities, duplicate sensors, bad DB records
from sensor operations.

## Search Keywords Used

Effective keyword combinations (Rovo Search):

1. "sensor schedule missing swap IWA" - found schedule-related tickets
2. "receiver schedule not applied replace IWA" - found swap/replace tickets
3. "sensor assigned two facilities duplicate IWA" - found dual-assignment bugs
4. "monitoring point modal sensor IWA" - found MP modal bugs
5. "Facility_Receiver MonitoringPoint_Receiver bad data IWA" - found DB integrity issues
6. "sensor removal reason missing guardrail IWA" - found missing guardrail tickets
7. "sensor transfer track inventory assigned devices IWA" - found transfer workflow bugs
8. "sensor schedule not pushed default overwrite IWA" - found schedule overwrite bugs

JQL `text ~` and `summary ~` searches returned 0 results for IWA
project — Rovo Search was essential.

## Patterns Identified

1. **Schedule not retained on sensor swap** - When sensors are
   swapped/replaced on MPs, the schedule stored on the sensor doesn't
   transfer to the new sensor
2. **Sensor-facility assignment integrity** - Sensors appearing in
   multiple facilities, orphaned sensors, duplicate records
3. **Missing guardrails in sensor operations** - No warnings when
   transferring sensors with assigned devices, missing removal reasons
4. **Bad DB records from sensor operations** - Facility_Receiver and
   MonitoringPoint_Receiver getting out of sync

## Final Ticket List

| Ticket | Summary | Status | Type | Priority |
|--------|---------|--------|------|----------|
| IWA-15202 | Sensor swap doesn't assign schedule | Ready for Tech Planning | Bug | P3 |
| IWA-14350 | Bulk assign MPs to updated schedule | Ready for Tech Planning | Task | P3 |
| IWA-11730 | Sensors assigned to two facilities | QA Failed | Bug | P3 |
| IWA-11444 | Two sensors on one MP | Ready for Development | Bug | P2 |
| IWA-11188 | 175 sensors in ART inventory and customer facility | Ready for Development | Bug | P2 |
| IWA-11643 | Duplicated sensors adding/removing via web | Cannot Reproduce | Bug | P2 |
| IWA-14947 | Removal reason not populated on part number change | Ready for Development | Bug | P3 |
| IWA-15326 | Assigned devices modal not shown for VERO transfer | Ready for Development | Bug | P3 |
| IWA-15368 | 504 error on sensors page | Ready for Development | Bug | Release Blocker |
| IWA-13056 | Resolving Battery Repair creates bad DB records | Ready for Development | Bug | P3 |
| IWA-14761 | Restore custom schedules overwritten by mobile sensor swaps | Ready for Development | Task | P2 |
| IWA-13571 | Swapping sensors doesn't retain MP schedules & rates | Ready for Development | Bug | P3 |
| IWA-10312 | 145 sensors not in a facility in production | Ready for Development | Bug | P3 |

## Final JQL

```
key in (IWA-15202, IWA-14350, IWA-11730, IWA-11444, IWA-11188, IWA-11643, IWA-14947, IWA-15326, IWA-15368, IWA-13056, IWA-14761, IWA-13571, IWA-10312)
```

## Lessons Learned

- Rovo Search is the only reliable way to search IWA ticket content
  through the API. JQL text/summary searches return 0 results.
- Running 5+ parallel searches with synonym variations is critical for
  comprehensive coverage.
- DB table names (Facility_Receiver, MonitoringPoint_Receiver) are
  effective search terms for finding data integrity bugs.
- Always fetch each ticket individually to verify status/type — Rovo
  results don't include enough metadata to filter without fetching.
- The `getJiraIssue` tool uses `issueIdOrKey`, not `issueKey`.
