// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./Erc20Rewards.sol";
import "./Erc721Collection.sol";

contract NFTStaking is Ownable,IERC721Receiver {

uint256 public totalStaked;
struct Stake{
    uint256 tokenId;
    uint256 timestamp;
    address owner;
}

event NFTStaked(address owner,uint256 tokenId,uint256 value);
event NFTUnstaked(address owner,uint256 tokenId,uint256 value);
event Claimed(address owner,uint256 amount);

Erc721Collection nft;
Erc20Rewards token;

mapping(uint256=>Stake) public vault;

constructor(Erc721Collection _nft,Erc20Rewards _token){
    nft=_nft;
    token=_token;
}

function StakeNft(uint256[] calldata _tokenIds) public {

for(uint i;i<_tokenIds.length;i++){
    require(nft.ownerOf(_tokenIds[i])==msg.sender,"You are not the owner of the tokens");
    require(vault[_tokenIds[i]].tokenId==0,"Already Staked");

    nft.transferFrom(msg.sender,address(this),_tokenIds[i]);

    vault[_tokenIds[i]]=Stake({
        owner:msg.sender,
        tokenId:_tokenIds[i],
        timestamp:block.timestamp
    });

    // vault[_tokenIds[i]].tokenid=_tokenIds[i];
    // vault[_tokenIds[i]].owner=msg.sender;
    // vault[_tokenIds[i]].timestamp=block.timestamp;
}

}
function UnStakeNft(address account,uint256[] calldata _tokenIds) public {
uint tokenId;
for(uint i;i<_tokenIds.length;i++){
tokenId=_tokenIds[i];
require(vault[tokenId].tokenId==tokenId,"This token id has no stake");
require(vault[tokenId].owner==msg.sender,"You are not the owner of this token");

delete(vault[tokenId]);
nft.transferFrom(address(this),account,tokenId);


}
}
}