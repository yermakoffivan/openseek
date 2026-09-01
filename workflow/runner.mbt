///|
/// The engine seam: HOW one agent call actually runs. The real runner
/// spawns child processes; unit tests inject a fake that never leaves the
/// process. Everything the run resolved to — success or failure, WITH its
/// cost — rides the returned `AgentOutcome`; `raise` carries only what
/// the workflow must not absorb: cancellation and engine bugs.
///
/// `validate_replay` guards STATEFUL outcomes at resume time: when a
/// journal hit is about to be served, the engine may inspect it against
/// live state (does the branch this outcome names still exist?) and veto
/// it — a vetoed entry stays consumed and the call runs live instead.
/// Engines whose outcomes are pure values need no validator: replay of a
/// plain report can never lie.
pub struct Runner {
  run : async (AgentCall) -> AgentOutcome
  validate_replay : (async (AgentCall, AgentOutcome) -> Bool)?
}

///|
/// Wrap a run function (and optionally a replay validator) as a `Runner`.
pub fn Runner::Runner(
  run : async (AgentCall) -> AgentOutcome,
  validate_replay? : async (AgentCall, AgentOutcome) -> Bool,
) -> Runner {
  { run, validate_replay, }
}
