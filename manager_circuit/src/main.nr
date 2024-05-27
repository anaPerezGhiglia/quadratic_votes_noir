use dep::std;

global CANDIDATE_COUNT = 10;
global VOTER_COUNT = 2;

fn main(commitments: pub [Field; VOTER_COUNT], all_votes: [u32; VOTER_COUNT * CANDIDATE_COUNT], secrets: [Field; VOTER_COUNT]) -> pub [u32; CANDIDATE_COUNT] {
    check_commitments(commitments, secrets, all_votes);
    sum_votes(all_votes)
}

fn sum_votes(all_votes: [u32; VOTER_COUNT * CANDIDATE_COUNT]) -> [u32; CANDIDATE_COUNT] {
    let mut totals = [0; CANDIDATE_COUNT];
    for voter_index in 0..VOTER_COUNT {
        for candidate_index in 0..CANDIDATE_COUNT {
            totals[candidate_index] = totals[candidate_index] + all_votes[(voter_index * CANDIDATE_COUNT) + candidate_index] ;
        }
    }
    totals
}

fn check_commitments(commitments: [Field; VOTER_COUNT], secrets: [Field; VOTER_COUNT], all_votes: [u32; VOTER_COUNT * CANDIDATE_COUNT]) {
    for voter_idx in 0..VOTER_COUNT{
        let mut transcript = [0; CANDIDATE_COUNT + 1];
        transcript[0] = secrets[voter_idx];
        for candidate_idx in 0..CANDIDATE_COUNT{
            transcript[candidate_idx + 1] = all_votes[voter_idx * CANDIDATE_COUNT + candidate_idx] as Field;
        }
        assert(commitments[voter_idx] == std::hash::pedersen_hash(transcript));
    }
}

