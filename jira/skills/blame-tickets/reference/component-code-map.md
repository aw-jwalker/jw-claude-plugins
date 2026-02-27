# Component-to-Code Area Mappings

Known mappings from Jira components to code paths in the project repos.
This file grows over time as more components are investigated.

## Repo: fullstack.assetwatch

| Component                     | Frontend                                                                                                                                          | Lambda                                             | Stored Procedures                                                |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------- | ---------------------------------------------------------------- |
| AssetDetail>AddEditMP         | `apps/frontend/src/components/UpdateMonitoringPointModal/`                                                                                        | `lambdas/lf-vero-prod-monitoringpoint/`            | `R__PROC_MonitoringPoint_*`, `R__PROC_MonitoringPointReceiver_*` |
| CustomerDetail>Sensors        | `apps/frontend/src/components/CustomerDetailPage/Sensors/`                                                                                        | `lambdas/lf-vero-prod-sensor/`                     | `R__PROC_Receiver_GetReceiverList*`                              |
| CustomerDetail>FacilityLayout | `apps/frontend/src/components/CustomerDetailPage/FacilityLayout/`                                                                                 | `lambdas/lf-vero-prod-global/CheckSensor.js`       | `R__PROC_FacilityLayoutTable_*`                                  |
| Hardware>HardwareEvents       | `apps/frontend/src/components/HardwareIssuePage/`, `apps/frontend/src/pages/HardwareEvents.tsx`                                                   | `lambdas/lf-vero-prod-hardwareissue/`              | `R__PROC_HardwareIssue_*`                                        |
| Hardware>TrackInventory       | `apps/frontend/src/components/TrackInventoryPage/`, `apps/frontend/src/pages/TrackInventory.tsx`                                                  | `lambdas/lf-vero-prod-inventory/`                  | `R__PROC_Inventory_*`                                            |
| Hardware>FacilityHardware     | `apps/frontend/src/pages/FacilityHardware.tsx`, `apps/frontend/src/components/FacilityHardwarePage/`, `apps/frontend/src/components/Schedule.tsx` | `lambdas/lf-vero-prod-sensor/` (schedule handlers) | `R__PROC_Receiver_*Schedule*`, `R__PROC_ReceiverSchedule_*`      |
| DB>Receivers                  | —                                                                                                                                                 | —                                                  | `R__PROC_Receiver_*`, `R__PROC_FacilityReceiver_*`               |
| AssetDetail                   | `apps/frontend/src/components/AssetDetailPage/`                                                                                                   | `lambdas/lf-vero-prod-monitoringpoint/`            | `R__PROC_MonitoringPoint_*`                                      |

## Repo: backend.jobs

| Component                            | Code Area                                                                                          |
| ------------------------------------ | -------------------------------------------------------------------------------------------------- |
| Hardware>HardwareEvents              | `terraform/jobs/jobs_hardware/`                                                                    |
| Hardware>FacilityHardware (schedule) | `terraform/jobs/jobs_schedule_optimizer/`, `terraform/jobs/request_v2/request-schedule/`           |
| DB>Receivers (provisioning)          | `terraform/jobs/jobs_data_ingestion_provision/`, `mysql/db/procs/R__PROC_Request_ProvisionSensor*` |

## Shared API Services (fullstack.assetwatch)

These frontend service files are shared across multiple components:

| Service File                                             | Components That Use It                                            |
| -------------------------------------------------------- | ----------------------------------------------------------------- |
| `apps/frontend/src/shared/api/SensorServices.ts`         | CustomerDetail>Sensors, Hardware>FacilityHardware, TrackInventory |
| `apps/frontend/src/shared/api/MonitoringPointService.ts` | AssetDetail>AddEditMP                                             |
| `apps/frontend/src/shared/api/HardwareIssueService.ts`   | Hardware>HardwareEvents                                           |
| `apps/frontend/src/shared/api/InventoryService.ts`       | Hardware>TrackInventory                                           |
| `apps/frontend/src/shared/api/FacilityServices.ts`       | CustomerDetail>FacilityLayout, AssetDetail>AddEditMP              |
| `apps/frontend/src/shared/api/RequestServiceV2.ts`       | AssetDetail>AddEditMP (schedule requests)                         |

## Notes

- Stored procedures are all in `mysql/db/procs/` with the `R__PROC_` prefix.
- Table change scripts (migrations) are in `mysql/db/table_change_scripts/`
  with `V{timestamp}__` prefix.
- See [../docs/README.md](../docs/README.md) for gotchas about monorepo
  refactors and formatting commits skewing git blame results.
