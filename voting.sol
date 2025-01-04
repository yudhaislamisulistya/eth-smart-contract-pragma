// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

contract Voting {
    struct Proposal {
        string name;
        string description;
        uint256 voteCount;
        uint256 startDate;
        uint256 endDate;
        address creator;
    }

    Proposal[] public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event ProposalCreated(
        uint256 indexed proposalId,
        string name,
        address indexed creator
    );
    event ProposalEdited(uint256 indexed proposalId, string newName);
    event Voted(uint256 indexed proposalId, address indexed voter);
    event VoteUndone(uint256 indexed proposalId, address indexed voter);

    function createProposal(
        string memory name,
        string memory description,
        uint256 startDate,
        uint256 endDate
    ) public {
        uint256 proposalId = proposals.length;
        proposals.push(Proposal({
            name: name,
            description: description,
            voteCount: 0,
            startDate: startDate,
            endDate: endDate,
            creator: msg.sender
        }));

        emit ProposalCreated(proposalId, name, msg.sender);
    }

    function editProposal(
        uint256 proposalId,
        string memory newName,
        string memory newDescription
    ) public {
        require(proposals[proposalId].creator == msg.sender, "You are not the creator of this proposal");

        proposals[proposalId].name = newName;
        proposals[proposalId].description = newDescription;

        emit ProposalEdited(proposalId, newName);
    }

    function vote(uint256 proposalId) public {
        require(proposalId < proposals.length, "Proposal does not exist");

        Proposal memory proposal = proposals[proposalId];
        require(block.timestamp >= proposal.startDate && block.timestamp <= proposal.endDate, "Voting is not allowed at this time");

        require(!hasVoted[proposalId][msg.sender], "You have already voted on this proposal");

        proposals[proposalId].voteCount++;
        hasVoted[proposalId][msg.sender] = true;

        emit Voted(proposalId, msg.sender);
    }

    function undoVote(uint256 proposalId) public {
        require(proposalId < proposals.length, "Proposal does not exist");

        require(hasVoted[proposalId][msg.sender], "You have not voted on this proposal");

        proposals[proposalId].voteCount--;
        hasVoted[proposalId][msg.sender] = false;

        // Emit event VoteUndone
        emit VoteUndone(proposalId, msg.sender);
    }

    function getProposal(
        uint256 proposalId
    )
        public
        view
        returns (
            string memory,
            string memory,
            uint256,
            uint256,
            uint256,
            address
        )
    {
        require(proposalId < proposals.length, "Proposal does not exist");

        Proposal memory proposal = proposals[proposalId];
        return (
            proposal.name,
            proposal.description,
            proposal.voteCount,
            proposal.startDate,
            proposal.endDate,
            proposal.creator
        );
    }

    function getAllProposals() public view returns (Proposal[] memory) {
        return proposals;
    }

    function getTotalProposals() public view returns (uint256) {
        return proposals.length;
    }
}
