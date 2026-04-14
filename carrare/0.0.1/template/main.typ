#import "../lib.typ": carrare

#show: carrare.with(
  title: "ARM Cortex M0+",
  domain: "Brussels",
  date: "June 2026",
)
= Introduction
#lorem(100)
#table(
  columns: (2fr, 1fr, 1fr, 1fr),
  [*Chip*],[*ID*],[*\# GPIO*],[*State*],
  "ARM Cortex M0+", "180325", "2", text(fill: red.darken(20%), strong(raw("Taken"))),
  "ARM Cortex M0+", "249179", "18", text(fill: red.darken(20%), strong(raw("Taken"))),
  "ARM Cortex M7", "820370", "6", text(fill: green.darken(20%), strong(raw("Available"))),
  "RPI Zero 2W", "293018", "40", text(fill: green.darken(20%), strong(raw("Available"))),
)
== Explaination
#lorem(100)
== Example
#lorem(20)
```rust
struct Scheduler {
  name: String,
  class: SchedClass,
  jobs: Vec<Jobs>,
}

trait Scheduling {
  fn schedule(&self, priorities: Vec<u32>);
  fn get_deadline_missed(&self) -> u32;
}
```
#lorem(200)
= Another section
#lorem(200)
= Implementation on GPUs
#lorem(200)
