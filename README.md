# voting-system

Foundry project for a Solidity voting system.

## What shoud do?

- A strcut Candidate { String name, uint256, votes;}
- An array of Candidates
- A mapping(addres => bool) to prevent double voting
- A vote(uint candidateId) function
- A winner() function that returns who has the most votes

**Criteria to advance**: you've written the voting system entierly on your own (syntax lookups are fins, but no copyng structure), it compiles with forge build, and has at least 3 passing tests with forge test.

## Usage

```shell
forge build
forge test
forge fmt
```

## Docs

https://book.getfoundry.sh/
