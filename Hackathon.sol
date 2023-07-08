// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Hackathon {
    struct Project {
        string title;
        uint[] ratings;
    }
    
    Project[] projects;

    // TODO: add the findWinner function

    function newProject(string calldata _title) external {
        // creates a new project with a title and an empty ratings array
        projects.push(Project(_title, new uint[](0)));
    }

    function rate(uint _idx, uint _rating) external {
        // rates a project by its index
        projects[_idx].ratings.push(_rating);
    }
    uint256 max = projects[0].ratings[0];
    uint index = 0;
    function findWinner() external returns(Project memory){
        for(uint i = 1;  i < projects.length; i++){
            if(projects[i].ratings[i] > max){
                max = projects[i].ratings[i];
                index = i;
            }
        }
        return projects[index];
    }
}
