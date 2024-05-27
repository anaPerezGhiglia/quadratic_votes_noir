use dep::std;
fn main(token_budget: pub u32, votes: [u32; CANDIDATE_COUNT], secret: Field) -> pub Field {
    check_within_budget(token_budget, votes);
    calculate_ballot_commitment(secret, votes)
}

global CANDIDATE_COUNT = 10;

fn check_within_budget(token_budget: u32, votes: [u32; CANDIDATE_COUNT]) { 
    let mut tokens_spent = 0;
    for vote in votes{
        tokens_spent = tokens_spent + (vote * vote);
    }
    assert(token_budget >= tokens_spent);
}

fn calculate_ballot_commitment(secret: Field, votes: [u32; CANDIDATE_COUNT]) -> Field {
    let mut transcript = [0; CANDIDATE_COUNT + 1];
    transcript[0] = secret;
    for i in 0..CANDIDATE_COUNT{
        transcript[i+1] = votes[i] as Field;
    }
    std::hash::pedersen_hash(transcript)
}
