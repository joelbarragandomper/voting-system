// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Voting, Candidate} from "../src/Voting.sol";

contract VotingTest is Test {
    Voting public voting;

    function setUp() public {
        voting = new Voting();
    }

    function testAddCandidate() public {
        voting.addCandidate("Alice");
        voting.addCandidate("Bob");

        (string memory name, uint256 votes, uint256 id) = voting.candidates(0);
        assertEq(name, "Alice");
        assertEq(votes, 0);
        assertEq(id, 0);

        (name, votes, id) = voting.candidates(1);
        assertEq(name, "Bob");
        assertEq(votes, 0);
        assertEq(id, 1);
    }

    function testVote() public {
        voting.addCandidate("Alice");
        voting.addCandidate("Bob");

        voting.vote(0);

        (, uint256 aliceVotes, ) = voting.candidates(0);
        (, uint256 bobVotes, ) = voting.candidates(1);
        assertEq(aliceVotes, 1);
        assertEq(bobVotes, 0);
        assertTrue(voting.hasVoted(address(this)));
    }

    function testWinner() public {
        voting.addCandidate("Alice");
        voting.addCandidate("Bob");

        voting.vote(0);

        Candidate memory candidate = voting.winner();
        assertEq(candidate.name, "Alice");
        assertEq(candidate.votes, 1);
        assertEq(candidate.id, 0);
    }

    function testCannotVoteTwice() public {
        voting.addCandidate("Alice");

        voting.vote(0);

        vm.expectRevert(bytes("You have already voted."));
        voting.vote(0);

        (, uint256 votes, ) = voting.candidates(0);
        assertEq(votes, 1);
        assertTrue(voting.hasVoted(address(this)));
    }

    function testCannotVoteForInvalidCandidate() public {
        voting.addCandidate("Alice");

        vm.expectRevert(bytes("Invalid candidate ID."));
        voting.vote(1);

        (, uint256 votes, ) = voting.candidates(0);
        assertEq(votes, 0);
        assertFalse(voting.hasVoted(address(this)));
    }

    function testWinnerWithNoCandidates() public {
        vm.expectRevert(bytes("No candidates have been added"));
        voting.winner();
    }

    function testWinnerWithNoVotes() public {
        voting.addCandidate("Alice");
        voting.addCandidate("Bob");

        vm.expectRevert(bytes("No votes have been cast."));
        voting.winner();
    }

    function testTwoDifferentUsersVotingSameCandidate() public {
        voting.addCandidate("Alice");
        voting.addCandidate("Bob");

        // First user votes for Alice
        voting.vote(0);

        // Simulate a second user votig for Alice
        address secondUser = makeAddr("secondUser");
        vm.prank(secondUser);
        voting.vote(0);

        Candidate memory candidate = voting.winner();
        assertEq(candidate.name, "Alice");
        assertEq(candidate.votes, 2);
    }
}
