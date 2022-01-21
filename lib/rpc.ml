type request_vote = {
  term: int;
  candidate_id: Candidate.t;
  last_log_index: int;
  last_log_term: int;
}

type append_entries = {
  term: int;
  leader_id: Candidate.t;
  prev_log_index: int;
  prev_log_term: int;
  entries: Logentry.t list;
  leader_commit: int
}

type t =
  | RequestVote of request_vote
  | AppendEntries of append_entries
