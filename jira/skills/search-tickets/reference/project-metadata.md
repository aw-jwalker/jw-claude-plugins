# Jira Project Metadata

## Atlassian Cloud

- **Cloud ID**: `1d52b6e0-a650-4fcd-a003-6f250217a316`
- **Instance**: nikolalabs.atlassian.net

## Projects

| Key | Name | Description |
|-----|------|-------------|
| IWA | AssetWatch Cloud Software | Main web application |
| AWM | AssetWatch Mobile | Mobile application |
| V0T | Vero Hardware | Hardware/firmware |

## Statuses (IWA Project)

### Open Statuses (include by default)

| Status | Meaning |
|--------|---------|
| Ready for Development | Ticket is ready to be worked on |
| In Development | Actively being worked on |
| QA Failed | Was tested, failed QA, needs rework |
| Ready for Tech Planning | Needs technical planning before dev |
| Needs Review | Code review needed |
| Cannot Reproduce | Bug could not be reproduced |
| Clarification | Needs more information |
| Ready for QA | Development done, awaiting QA |

### Closed Statuses (exclude by default)

| Status | Meaning |
|--------|---------|
| Live | Deployed to production |
| Closed | Completed and closed |
| Obsolete | No longer relevant |

## Common Components (IWA)

| Component | Area |
|-----------|------|
| AssetRisk | Risk assessment features |
| AssetDetail | Asset detail pages |
| CustomerDetail>Sensors | Sensor management under customers |
| Release>Blocker | Release blocking issues |

## Ticket Types

| Type | When to Include |
|------|-----------------|
| Bug | Defects, broken behavior (most common for search) |
| Task | Work items, improvements (common for search) |
| Story | Feature requests (occasionally relevant) |
| Epic | Feature groups (usually not for bug searches) |
| Sub-task | Child tasks (usually fetched via parent) |

## Key Database Tables (Sensor Domain)

These table names appear frequently in sensor-related tickets:

| Table | Purpose |
|-------|---------|
| Facility_Receiver | Which sensors are assigned to which facility |
| MonitoringPoint_Receiver | Which sensor is on which monitoring point |
| ReceiverSchedule | Schedule/rate configuration for sensors |
| Facility_ReceiverHistory | Historical record of sensor assignments |

## Key Frontend Files (Sensor Domain)

| File | Purpose |
|------|---------|
| UpdateMonitoringPointModal | Add/Edit MP modal |
| useMonitoringPointSubmit.ts | MP submit logic including schedule push |
| MonitoringPointService.ts | MP API calls |
| RequestServiceV2.ts | Schedule request APIs |
