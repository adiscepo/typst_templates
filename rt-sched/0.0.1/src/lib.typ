#import "@preview/cetz:0.5.3"

#let config = (
  task_height: 0.8cm,
  step_width: 2em,
)

#let task_label(i) = $tau_#i$

#let task-pos(i, t: 0) = {
  (x: t, y: config.task_height * i)
}

#let plot(
  from: int,
  to: int,
  step: int,
  scheduler: function,
  tasks: array,
  config: config,
) = {
  cetz.canvas({
    import cetz.draw: *

    if (to - from < 0) {
      panic("Incorrect interval [" + str(from) + ", " + str(to) + ")")
    }

    // X-axis ticks
    for j in range(0, to - from, step: step, inclusive: true) {
      let i = config.step_width * j
      // Tick
      line((i, 0), (i, -0.1))
      // Value
      content((i, -0.3), [#(j + from)])
      // Line-separator
      line(
        (i, 0),
        (i, config.task_height * tasks.len()),
        stroke: (dash: "dotted", thickness: 0.6pt, paint: gray),
      )
    }
    // X-axis
    line((0, 0), (config.step_width * (to - from), 0))

    // Y-axis lines
    for task_number in range(1, tasks.len() + 1) {
      let task_pos = task-pos(task_number)
      // Tick
      line((-0.2, task_pos.y), (0, task_pos.y))
      // Y-Label
      content(
        (-0.5, task_pos.y - (config.task_height / 2)),
        task_label(task_number),
      )
      // Line-separator
      line(
        (0, task_pos.y),
        (config.step_width * (to - from), task_pos.y),
        stroke: (dash: "dotted", thickness: 1pt, paint: gray),
      )
      // Y-axis
      line((0, 0), task-pos(tasks.len()))
    }

    // Print a content for task task_id at instant t
    let plot-mark(task_id, t, dx: 0mm, dy: 1mm, ..content) = {
      let task = tasks.at(task_id - 1)
      let task-pos = task-pos(task_id - 1, t: t)
      // Prevent printing the mark outside the plot
      if (t <= to) {
        let x-pos = config.step_width * t
        let y-pos = task-pos.y
        mark(
          (x-pos + dx, y-pos + config.task_height - dy),
          (x-pos + dx, y-pos),
          ..content,
        )
      }
    }

    let plot-deadline(task_id, t) = {
      let task = tasks.at(task_id - 1)
      let task-pos = task-pos(task_id, t: t)
      let x-deadline = t - from + task.d
      plot-mark(task_id, t, dy: config.task_height / 2, "x", scale: 0.7)
    }

    let job(task_id, task, t) = {
      // task_id
      // release instant
      // absolute deadline
      // remaining time
      (
        task_id: task_id,
        task: task,
        release: t,
        deadline: t + task.d,
        remaining_computation: task.c,
      )
    }

    let spawn_jobs(tasks, t) = {
      let new_jobs = ()
      for (i, task) in tasks.enumerate() {
        if (calc.rem(t, task.t) == 0) {
          new_jobs.push(job(i + 1, task, t))
        }
      }
      return new_jobs
    }

    let plot-execution(task_id, t, n: 1, fill: color.blue.transparentize(100%)) = {
      let task = tasks.at(task_id - 1)
      let task-pos = task-pos(task_id - 1, t: t)
      rect(
        (task-pos.x * config.step_width, task-pos.y),
        ((task-pos.x + n) * config.step_width, task-pos.y + config.task_height),
        // fill: colors.at(task_id - 1),
        // stroke: 0pt,
      )
    }

    // plot-mark(2, 6, dy: 4mm, "x", stroke: 1pt + red)
    let running_jobs = ()
    let current_job = none
    let deadline_missed = false
    // Schedule
    for t in range(from, to) {
      // Check deadline miss
      for job in running_jobs {
        if (job.deadline <= t and job.remaining_computation != 0) {
          plot-mark(
            running_jobs.at(0).task_id,
            t,
            dx: config.step_width / 2,
            dy: config.task_height / 2,
            "x",
            stroke: 1pt + red,
          )
          deadline_missed = true
        }
      }
      if (deadline_missed) { break }
      // Spawn jobs
      for job in spawn_jobs(tasks, t) {
        running_jobs.push(job)
      }
      // schedule for one step
      // schedule() put the highest priority job at the beginning of the list
      running_jobs = scheduler(running_jobs, t)
      if (running_jobs.len() > 0) {
        plot-execution(running_jobs.at(0).task_id, t)
        running_jobs.at(0).remaining_computation -= 1
        running_jobs = running_jobs.filter(job => job.remaining_computation > 0)
      }
    }

    // Task informations
    for task in range(1, tasks.len() + 1) {
      for t in range(from, to, inclusive: true) {
        let task-pos = task-pos(task, t: t)
        // - 1 because tasks starts at 1 but array at 0
        let task-param = tasks.at(task - 1)
        let x-pos = config.step_width * (t - from)
        // Releases
        if (calc.rem(t, task-param.t) == 0) {
          line(
            (x-pos, task-pos.y - (config.task_height / 4)),
            (x-pos, task-pos.y),
            mark: (start: "barbed", length: config.task_height / 10),
          )
          // Deadline
          if (t != 0) {
            plot-deadline(task, t)
          }
        }
      }
    }
  })
}

#let is-synchronous(tasks) = {
  for task in tasks { if (task.keys().contains("o")) { if task.o != 0 { return false } } }
  return true
}

#let is-implicit(tasks) = {
  for task in tasks { if task.d != task.t { return false } }
  return true
}

#let is-constrained(tasks) = {
  for task in tasks { if task.d > task.t { return false } }
  return true
}

#let is-arbitrary(tasks) = {
  return not is-constrained(tasks)
}

#let describe-taskset(tasks) = {
  if is-synchronous(tasks) { "synchronous" } else { "asynchronous" } + " "
  (
    if is-implicit(tasks) { "implicit" } else if is-constrained(tasks) { "constrained" } else { "arbitrary" }
      + "-deadline system"
  )
}

#let utilization(tasks) = {
  tasks.map(task => task.c / task.t).sum()
}

#let hyperperiod(tasks) = {
  let res = tasks.first().t
  for (i, task) in tasks.enumerate() {
    if (i != 0) {
      res = calc.lcm(res, task.t)
    }
  }
  res
}

#let print-taskset(tasks) = {
  if is-synchronous(tasks) {
    table(
      columns: 4,
      align: center,
      stroke: 0pt,
      [$tau_i$], [$C_i$], [$D_i$], [$T_i$],
      table.hline(stroke: 1pt),
      ..for (i, task) in tasks.enumerate() {
        (
          [$tau_#{ i + 1 }$],
          table.vline(stroke: 1pt),
          [$#task.c$],
          [$#task.d$],
          [$#task.t$],
        )
      },
    )
  } else {
    table(
      columns: 5,
      align: center,
      stroke: 0pt,
      [$tau_i$], [$O_i$], [$C_i$], [$D_i$], [$T_i$],
      table.hline(stroke: 1pt),
      ..for (i, task) in tasks.enumerate() {
        (
          [$tau_#{ i + 1 }$],
          table.vline(stroke: 1pt),
          if (task.keys().contains("o")) [$#task.o$] else [$0$],
          [$#task.c$],
          [$#task.d$],
          [$#task.t$],
        )
      },
    )
  }
}



#let tasks = (
  (o: 0, c: 2, d: 5, t: 5),
  (o: 0, c: 1, d: 10, t: 10),
  (o: 3, c: 1, d: 4, t: 4),
  (o: 0, c: 1, d: 4, t: 4),
)

#let tasks = (
  (c: 2, d: 8, t: 8),
  (c: 3, d: 10, t: 10),
  (c: 5, d: 14, t: 14),
)

// #let tasks = (
//   (c: 30, d: 100, t: 100),
//   (c: 50, d: 100, t: 150),
//   (c: 5, d: 100, t: 40),
// )

#print-taskset(tasks)
// #describe-taskset(tasks)

// #utilization(tasks)

// #hyperperiod(tasks)


#let config = (
  task_height: 0.8cm,
  step_width: 2em,
)
#let rm(running_jobs, t) = {
  return running_jobs.sorted(key: it => it.task.t)
}

#let dm(running_jobs, t) = {
  return running_jobs.sorted(key: it => it.task.d)
}

#let edf(running_jobs, t) = {
  return running_jobs.sorted(key: it => it.deadline)
}

#plot(from: 0, to: 20, step: 2, scheduler: rm, tasks: tasks, config: config)

#plot(from: 0, to: 20, step: 1, scheduler: edf, tasks: tasks, config: config)

