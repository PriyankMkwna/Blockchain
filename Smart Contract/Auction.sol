// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract Auction {
    uint n=1;
    string[] names;
    struct items
    {
        string itemName;
        string description;
        bool forSale;
        address owner;
        uint floorPrice;
        address temp;
    }
    struct Bids
    {
        address bidder;
        uint bidCount;
        uint bidPrices;
    }
    mapping (uint=>items) public itemsss;
    mapping (uint=>Bids) public bidsss;
    uint[] public Ids;
    event itemSold(uint Ids);

    function listItems(string memory _itemName,string memory _description,uint _floorPrice) public {
        items memory newitems = items(
            {
                itemName : _itemName,
                description : _description,
                forSale : true ,
                owner : msg.sender,
                floorPrice: _floorPrice,
                temp : msg.sender
            }
        );
        uint temp1 = newitems.floorPrice;
        Bids memory newbids = Bids(
            {
                bidder : address(0),
                bidCount: 0,
                bidPrices : temp1
            }
        );
        names.push(_itemName);
        Ids.push(n);
        itemsss[n] = newitems;
        bidsss[n] = newbids;
        n++; 
    }

    function MakeBid(uint _id,uint _bidPrice) public payable {
        items memory newitem = itemsss[_id];
        Bids memory newBid = bidsss[_id];
        require(newitem.forSale,"Not for Sale");
        require(newitem.floorPrice <= _bidPrice,"Invalid Bid");
        require(newBid.bidPrices<_bidPrice,"Make Higher Bid"); 
        if (newBid.bidder != address(0)) {
            payable(newBid.bidder).transfer(newBid.bidPrices);
        }
        newBid.bidCount++;   
        newBid.bidPrices=_bidPrice;
        newitem.temp=msg.sender;
        newBid.bidder = msg.sender;
        itemsss[_id]=newitem;
        bidsss[_id]=newBid;
    }

    function CheckHighestBid(uint _id)public view returns(uint) {
        Bids storage checkbid = bidsss[_id];
        return checkbid.bidPrices;
    }

    function AllListedItems() public view returns(string[] memory,uint[] memory) {
        return (names,Ids);
    }

    function CheckBidCount(uint _id)public view returns(uint) {
        Bids storage checkbid = bidsss[_id];
        return checkbid.bidCount;
    }

    function BidResult(uint _id) public payable  {
        items storage newitem = itemsss[_id];
        Bids storage newBid = bidsss[_id];
        require(newBid.bidCount > 0, "No bids yet");
        newitem.owner = newBid.bidder;
        newitem.forSale = false;
    }
}