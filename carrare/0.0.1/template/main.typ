#import "../lib.typ": carrare

#show: carrare.with(
  title: "ARM Cortex M0+",
  domain: "Brussels",
  date: "June 2026",
)
= Introduction
#lorem(100)
#let taken = text(fill: red.darken(20%), strong(raw("Taken")))
#let available = text(fill: green.darken(20%), strong(raw("Available")))
#figure(
  table(
    columns: (2fr, 1fr, 1fr, 1fr),
    [*Chip*], [*ID*], [*\# GPIO*], [*State*],
    "ARM Cortex M0+", "180325", "2", taken,
    "ARM Cortex M0+", "249179", "18", taken,
    "ARM Cortex M7", "820370", "6", available,
    "RPI Zero 2W", "293018", "40", available,
  ),
  caption: "List of available chips",
)
= Explaination
#lorem(100)
== Example
#lorem(20)
=== Implementation in Rust
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
=== Implementation in C
#lorem(20)
= Another section
#lorem(200)
= Implementation on GPUs
#lorem(200)
