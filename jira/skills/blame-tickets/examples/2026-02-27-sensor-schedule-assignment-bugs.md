# 2026-02-27 - Sensor Schedule & Assignment Bugs (13 Tickets)

## Context

User had a list of 13 Jira tickets (sensor-related bugs) and needed to
identify which developer should be assigned to each based on code ownership.
Tickets came from a previous `jira:search-tickets` session.

## Tickets

| Ticket    | Summary                                             | Component                     | Status                  |
| --------- | --------------------------------------------------- | ----------------------------- | ----------------------- |
| IWA-15202 | Sensor swap doesn't assign schedule to new sensor   | AssetDetail>AddEditMP         | Ready for Tech Planning |
| IWA-14350 | Bulk assign MPs to updated schedule                 | (none)                        | Ready for Tech Planning |
| IWA-11730 | Sensors assigned to two facilities at once          | AssetDetail>AddEditMP         | QA Failed               |
| IWA-11444 | Two sensors on one MP, another has none             | AssetDetail>AddEditMP         | Ready for Development   |
| IWA-11188 | 175 sensors in ART inventory and customer facility  | DB>Receivers                  | Ready for Development   |
| IWA-11643 | Duplicated sensors adding/removing via web          | CustomerDetail>FacilityLayout | Cannot Reproduce        |
| IWA-15326 | Assigned devices modal not shown for VERO transfer  | Hardware>TrackInventory       | Ready for Development   |
| IWA-15368 | 504 error on sensors page                           | CustomerDetail>Sensors        | Live (already fixed)    |
| IWA-13056 | Battery repair resolve creates bad DB records       | Hardware>HardwareEvents       | Ready for Development   |
| IWA-14761 | Restore custom schedules overwritten by mobile swap | AssetDetail>AddEditMP         | Ready for Development   |
| IWA-13571 | Sensor swap doesn't retain MP schedules & rates     | AssetDetail                   | Ready for Development   |
| IWA-10312 | 145 sensors not in a facility                       | DB>Receivers                  | Ready for Development   |
| IWA-15344 | Missing schedule tool issue                         | Hardware>FacilityHardware     | Ready for Development   |

## Investigation Groups

### Group 1: AddEditMP / Sensor Swap (6 tickets)

- Tickets: IWA-15202, IWA-14761, IWA-13571, IWA-11730, IWA-11444, IWA-14350
- Repos: fullstack.assetwatch
- Key files: `useMonitoringPointSubmit.ts`, `sensorValidation.ts`,
  `UpdateMonitoringPointModal.tsx`, `MonitoringPointReceiver_Merge.sql`,
  `GetLastReceiverSchedule_v2.sql`, `AddMonitoringPointFromAW.sql`

### Group 2: DB/Receivers / Sensor Inventory (3 tickets)

- Tickets: IWA-11188, IWA-10312, IWA-11643
- Repos: fullstack.assetwatch, backend.jobs
- Key files: `Receiver_AddReceiverDetail.sql`, `FacilityReceiver_UpdateReceiverStatus.sql`,
  `Receiver_RemoveReceiver.sql`, `FacilityLayoutTab.tsx`

### Group 3: Hardware Events / Track Inventory (2 tickets)

- Tickets: IWA-13056, IWA-15326
- Repos: fullstack.assetwatch, backend.jobs
- Key files: `ResolveHardwareIssues.tsx`, `ResolveHardwareIssue.sql`,
  `TrackInventoryHeader.tsx`, `AssignedHardwareConfirmationModal.tsx`

### Group 4: Sensors Page 504 / Schedule Tool (2 tickets)

- Tickets: IWA-15368, IWA-15344
- Repos: fullstack.assetwatch, backend.jobs
- Key files: `Receiver_GetReceiverList.sql`, `FacilityHardware.tsx`,
  `GenTwoCard.tsx`, `Schedule.tsx`

## Results

| Ticket    | Recommended Assignee        | Secondary       | Last Activity                       | Key Code Area                                                    |
| --------- | --------------------------- | --------------- | ----------------------------------- | ---------------------------------------------------------------- |
| IWA-15202 | Melissa Fox                 | Josh Roesslein  | Feb 3, 2026                         | useMonitoringPointSubmit.ts                                      |
| IWA-13571 | Melissa Fox                 | Josh Roesslein  | Feb 3, 2026                         | useMonitoringPointSubmit.ts                                      |
| IWA-11444 | Melissa Fox                 | BrandonD09      | Feb 3, 2026                         | sensorValidation.ts, MonitoringPointReceiver_Merge.sql           |
| IWA-11730 | Melissa Fox                 | aw-jwalker      | Jan 28, 2026 (PR #922)              | sensorValidation.ts, updateSensorFacilityStatus                  |
| IWA-14761 | Mobile Backend team         | Melissa Fox     | Jan 2025 (telsinger)                | AddMonitoringPointFromMobile.sql, GetLastReceiverSchedule_v2.sql |
| IWA-14350 | Darren Ybarra               | venkata.bolneni | Dec 2025                            | AddReceiverSchedule_Iterator.sql, PopulateScheduledReadings.sql  |
| IWA-11643 | BrandonD09                  | Izayah Gibson   | Feb 4, 2026                         | FacilityReceiver_UpdateReceiverStatus.sql, FacilityLayoutTab.tsx |
| IWA-11188 | BrandonD09                  | telsinger       | Feb 4, 2026                         | Receiver_AddReceiverDetail.sql                                   |
| IWA-10312 | BrandonD09                  | Chris MacSwan   | Feb 4, 2026                         | Receiver_RemoveReceiver.sql, Receiver_AddReceiverDetail.sql      |
| IWA-15326 | BrandonD09                  | Chris MacSwan   | Oct 2025 (Brandon), Feb 5 (jwalker) | TrackInventoryHeader.tsx                                         |
| IWA-13056 | Ryan Erricson               | aw-jwalker      | Sep 2025 (jwalker on proc)          | ResolveHardwareIssue.sql, ResolveHardwareIssues.tsx              |
| IWA-15344 | Chris MacSwan               | telsinger       | Feb 25, 2026                        | GenTwoCard.tsx, Schedule.tsx                                     |
| IWA-15368 | Already fixed (Melissa Fox) | —               | Feb 26, 2026                        | Receiver_GetReceiverList.sql (indexes added)                     |

## Load Distribution

| Developer      | Count | Tickets                                    |
| -------------- | ----- | ------------------------------------------ |
| Melissa Fox    | 4     | IWA-15202, IWA-13571, IWA-11444, IWA-11730 |
| BrandonD09     | 4     | IWA-11643, IWA-11188, IWA-10312, IWA-15326 |
| Chris MacSwan  | 1     | IWA-15344                                  |
| Ryan Erricson  | 1     | IWA-13056                                  |
| Darren Ybarra  | 1     | IWA-14350                                  |
| Mobile Backend | 1     | IWA-14761                                  |
| Already fixed  | 1     | IWA-15368                                  |

## Lessons Learned

- **Grouping by component before investigating is critical.** The 4-group
  approach (vs 13 individual investigations) completed in ~5 minutes with
  parallel sub-agents.
- **The Jan 2026 monorepo refactor skews git blame.** Zac Klammer moved
  all frontend files from `packages/` to `apps/`, so blame shows him as
  author of most lines. Need to check blame at pre-refactor commits for
  true ownership.
- **Jira components map well to code directories** but not perfectly.
  `AssetDetail>AddEditMP` maps to `UpdateMonitoringPointModal/`, not
  a directory literally named "AddEditMP".
- **Historical bug fix commits are highly valuable.** Josh Roesslein had
  fixed sensor swap schedule bugs 3 times before, making him a strong
  secondary for those tickets even though Melissa Fox owns the most code.
- **`thoughts/` directory is worth checking first.** Found existing research
  for IWA-11730 that confirmed aw-jwalker had already been working on it.
- **Related tickets should be flagged for consolidation.** IWA-15202 and
  IWA-13571 appear to be the same underlying bug. IWA-11188, IWA-10312,
  and IWA-11643 are all sensor inventory integrity issues likely sharing
  a root cause.
- **Brandon's Feb 24 commit** ("Remove duplicated logic with adding to
  Facility_Receiver tables") may already fix the root cause for multiple
  tickets in his group -- worth verifying before assigning all 4.
