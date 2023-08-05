// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    // Structure to store campaign information
    struct Campaign {
        address owner;          // Address of the campaign owner
        string title;           // Title of the campaign
        string description;     // Description of the campaign
        uint256 target;         // Fundraising target amount
        uint256 deadline;       // Deadline for the campaign in UNIX timestamp
        uint256 amountCollected; // Amount of funds collected so far
        string image;           // URL to the campaign image
        address[] donators;     // Array to store addresses of donors
        uint256[] donations;    // Array to store donation amounts
    }

    // Mapping to store campaigns with their unique IDs
    mapping(uint256 => Campaign) public campaigns;

    // Counter to keep track of the total number of campaigns
    uint256 public numberOfCampaigns = 0;

    // Function to create a new campaign
    function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns (uint256) {
        // Get a reference to the new campaign using its ID
        Campaign storage campaign = campaigns[numberOfCampaigns];

        // Ensure that the deadline is set in the future
        require(_deadline > block.timestamp, "The deadline should be a date in the future.");

        // Initialize campaign properties
        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        // Increment the campaign counter and return the new campaign's ID
        numberOfCampaigns++;
        return numberOfCampaigns - 1;
    }

    // Function to donate to a campaign
    function donateToCampaign(uint256 _id) public payable {
        uint256 amount = msg.value;

        // Get a reference to the campaign being donated to
        Campaign storage campaign = campaigns[_id];

        // Add donor's address and donation amount to respective arrays
        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        // Attempt to transfer the donation amount to the campaign owner
        (bool sent,) = payable(campaign.owner).call{value: amount}("");

        // If transfer is successful, update the collected amount
        if (sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    // Function to retrieve a campaign's donors and their donations
    function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory) {
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    // Function to retrieve all campaigns
    function getCampaigns() public view returns (Campaign[] memory) {
        // Create an array to hold all campaigns
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        // Populate the array with campaign data
        for (uint i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];
            allCampaigns[i] = item;
        }

        return allCampaigns;
    }
}
