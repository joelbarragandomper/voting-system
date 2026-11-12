// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

struct Candidate {
    string name;
    uint256 votes;
    uint256 id;
}

contract Voting {
    Candidate[] public candidates;
    mapping(address => bool) public hasVoted;

    function addCandidate(string memory _name) public {
        candidates.push(Candidate(_name, 0, candidates.length));
    }

    function vote(uint256 _candidateId) public {
        require(!hasVoted[msg.sender], "You have already voted.");
        require(_candidateId < candidates.length, "Invalid candidate ID.");

        Candidate storage candidate = candidates[_candidateId];
        candidate.votes++;
        hasVoted[msg.sender] = true;
    }

    function winner() public view returns (Candidate memory _winner) {
        require(candidates.length > 0, "No candidates have been added");
        uint256 winningVoteCount = 0;
        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].votes > winningVoteCount) {
                winningVoteCount = candidates[i].votes;
                _winner = candidates[i];
            }
        }
        require(winningVoteCount > 0, "No votes have been cast.");
        return _winner;
    }
}
