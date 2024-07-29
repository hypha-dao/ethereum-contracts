// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./DocumentGraph.sol";

/**
* POC - these functions are just stubs for the real methods they are not real implementations of a DAO. 
**/
contract DAO is DocumentGraph {

    event MemberAdded(uint256 daoId, uint256 memberId);
    event ProposalCreated(uint256 daoId, uint256 proposalId);
    event VoteCasted(uint256 proposalId, uint256 memberId, bool vote);

    function addMember(uint256 _daoId, uint256 _memberId) public {
        require(_daoId > 0 && _daoId <= documentCount, "Invalid DAO ID");
        require(_memberId > 0 && _memberId <= documentCount, "Invalid member ID");

        addEdge(_daoId, "member", _memberId);
        emit MemberAdded(_daoId, _memberId);
    }

    function createProposal(uint256 _daoId, string memory _proposalDescription) public returns (uint256) {
        require(_daoId > 0 && _daoId <= documentCount, "Invalid DAO ID");

        uint256 proposalId = createDocument("proposal");
        setStringProperty(proposalId, "description", _proposalDescription);
        addEdge(_daoId, "proposal", proposalId);
        emit ProposalCreated(_daoId, proposalId);
        return proposalId;
    }

    function castVote(uint256 _proposalId, uint256 _memberId, bool _vote) public {
        require(_proposalId > 0 && _proposalId <= documentCount, "Invalid proposal ID");
        require(_memberId > 0 && _memberId <= documentCount, "Invalid member ID");

        addEdge(_proposalId, _vote ? "yesVote" : "noVote", _memberId);
        emit VoteCasted(_proposalId, _memberId, _vote);
    }

    function getProposalVotes(uint256 _proposalId) public view returns (uint256[] memory yesVotes, uint256[] memory noVotes) {
        require(_proposalId > 0 && _proposalId <= documentCount, "Invalid proposal ID");

        yesVotes = getEdges(_proposalId, "yesVote");
        noVotes = getEdges(_proposalId, "noVote");
    }
}
